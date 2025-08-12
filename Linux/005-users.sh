#!/usr/bin/env bash

set -euo pipefail

# Verificamos si es root, ya que se usarán comandos como 'passwd' y 'chage'.
if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

generate_data() {
    # Procesa todos los usuarios para generar los datos con una clave de ordenamiento.
    # Clave 1 (shell): 0 para shell activo, 1 para inactivo.
    # Clave 2 (login): 0 para usuarios que han iniciado sesión, 1 para los que nunca lo han hecho.
    # Esto ordena: 1. Activos con login, 2. Activos sin login, 3. Inactivos.
    # Formato de salida: sort_key1|sort_key2|USUARIO|...

    awk -F: '$1 != "nobody" {print $1, $7}' /etc/passwd | while read -r user shell; do
        local sort_key1
        local sort_key2
        local shell_status
        local password_status
        local locked_status
        local expiry_status
        local last_change_status
        local min_max_days
        local last_login_status

        # Verificar tipo de shell
        if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
            sort_key1=1 # Shell inactivo
            sort_key2=9 # No relevante para este grupo
            shell_status="🔴 NO SHELL"
            password_status="N/A"
            locked_status="N/A"
            expiry_status="N/A"
            last_change_status="N/A"
            min_max_days="N/A"
            last_login_status="N/A"
        else
            sort_key1=0 # Shell activo
            shell_status="🟢 SHELL: $shell"
            # Verificar estado de contraseña (usando passwd -S)
            password_info=$(passwd -S "$user" 2>/dev/null)
            if [ -z "$password_info" ]; then
                password_status="❓ NO EXISTE"
                locked_status="N/A"
                expiry_status="N/A"
                last_change_status="N/A"
                min_max_days="N/A"
                last_login_status="N/A"
            else
                # Extraer estado (L=bloqueada, P=activa, NP=sin contraseña) 
                password_state=$(echo "$password_info" | awk '{print $2}') 
                case "$password_state" in
                    "L") password_status="🔒 BLOQUEADA";;
                    "P") password_status="🟢 ACTIVA   ";;
                    "NP") password_status="🔓 SIN CONTRASEÑA";;
                    *) password_status="❓ $password_state";;
                esac

                # Verificar si está bloqueada (reutilizando la salida de passwd -S)
                if echo "$password_info" | grep -q "locked"; then
                    locked_status="🔐 BLOQUEADA"
                else
                    locked_status="✅ DESBLOQUEADA"
                fi

                # Obtener y formatear datos de políticas de contraseña con chage
                chage_info=$(chage -l "$user" 2>/dev/null)

                expiry_date=$(echo "$chage_info" | awk -F: '/^Password expires/ {print $2}' | xargs)
                if [[ -z "$expiry_date" || "$expiry_date" == "never" ]]; then
                    expiry_status="Nunca"
                else
                    expiry_status="$expiry_date"
                fi

                last_change=$(echo "$chage_info" | awk -F: '/^Last password change/ {print $2}' | xargs)
                if [[ -z "$last_change" || "$last_change" == "never" ]]; then
                    last_change_status="Nunca"
                else
                    last_change_status="$last_change"
                fi

                min_days=$(echo "$chage_info" | awk -F: '/^Minimum number of days/ {print $2}' | xargs)
                max_days=$(echo "$chage_info" | awk -F: '/^Maximum number of days/ {print $2}' | xargs)
                min_max_days="${min_days:-?}/${max_days:-?}"

                # Obtener último login interactivo
                last_login_info=$(LC_ALL=C lastlog -u "$user" 2>/dev/null | tail -n 1)
                if echo "$last_login_info" | grep -q -F '**Never logged in**'; then
                    sort_key2=1 # Nunca ha iniciado sesión
                    last_login_status="Nunca"
                else
                    sort_key2=0 # Ha iniciado sesión
                    # Extraer la fecha de forma robusta, buscando el día de la semana
                    # y tomando el resto de la línea. Esto evita problemas con distintos
                    # formatos de salida de `lastlog` o locales.
                    last_login_status=$(echo "$last_login_info" | awk '{
                        for (i=1; i<=NF; i++) {
                            if ($i ~ /^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)$/) {
                                for (j=i; j<=NF; j++) { printf "%s ", $j }
                                print ""
                                exit
                            }
                        }
                    }' | xargs)
                fi
            fi
        fi
        # Imprimir fila con delimitador para que 'column' la procese.
        echo "$sort_key1|$sort_key2|$user|$shell_status|$password_status|$locked_status|$expiry_status|$last_change_status|$min_max_days|$last_login_status"
    done
}

cs
# Encabezado de la tabla
HEADER="USUARIO|SHELL|ESTADO PASS|BLOQUEO|EXPIRACIÓN|ÚLTIMO CAMBIO|DÍAS MIN/MAX|ÚLTIMO LOGIN"

# Generar datos, ordenarlos por la primera columna (clave de ordenamiento),
# quitar la clave, y luego formatear la tabla.
(
    echo "$HEADER"
    generate_data | sort -t'|' -k1,1n -k2,2n | cut -d'|' -f3-
) | column -t -s '|' -o ' | '
echo ""