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
    # La clave (0 o 1) se usa para poner a los usuarios con shell activo primero.
    # Formato de salida: sort_key|USUARIO|SHELL|ESTADO PASS|BLOQUEO|EXPIRACIÓN

    awk -F: '$1 != "nobody" {print $1, $7}' /etc/passwd | while read -r user shell; do
        local sort_key
        local shell_status
        local password_status
        local locked_status
        local expiry_status

        # Verificar tipo de shell
        if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
            sort_key=1 # Shell inactivo
            shell_status="🔴 NO SHELL"
            password_status="N/A"
            locked_status="N/A"
            expiry_status="N/A"
        else
            sort_key=0 # Shell activo
            shell_status="🟢 SHELL: $shell"
            # Verificar estado de contraseña (usando passwd -S)
            password_info=$(passwd -S "$user" 2>/dev/null)
            if [ -z "$password_info" ]; then
                password_status="❓ NO EXISTE"
                locked_status="N/A"
                expiry_status="N/A"
            else
                # Extraer estado (L=bloqueada, P=activa, NP=sin contraseña)
                password_state=$(echo "$password_info" | awk '{print $2}')
                case "$password_state" in
                    "L") password_status="🔒 BLOQUEADA";;
                    "P") password_status="🟢 ACTIVA";;
                    "NP") password_status="🔓 SIN CONTRASEÑA";;
                    *) password_status="❓ $password_state";;
                esac

                # Verificar si está bloqueada (reutilizando la salida de passwd -S)
                if echo "$password_info" | grep -q "locked"; then
                    locked_status="🔐 BLOQUEADA"
                else
                    locked_status="✅ DESBLOQUEADA"
                fi

                # Obtener caducidad (chage)
                expiry_date=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d ":" -f 2- | xargs)
                if [[ -z "$expiry_date" || "$expiry_date" == "never" ]]; then
                    expiry_status="Nunca"
                else
                    expiry_status="$expiry_date"
                fi
            fi
        fi
        # Imprimir fila con delimitador para que 'column' la procese.
        echo "$sort_key|$user|$shell_status|$password_status|$locked_status|$expiry_status"
    done
}

cs
# Encabezado de la tabla
HEADER="USUARIO|SHELL|ESTADO PASS|BLOQUEO|EXPIRACIÓN"

# Generar datos, ordenarlos por la primera columna (clave de ordenamiento),
# quitar la clave, y luego formatear la tabla.
(
    echo "$HEADER"
    generate_data | sort -t'|' -k1,1n | cut -d'|' -f2-
) | column -t -s '|' -o ' | '
echo ""