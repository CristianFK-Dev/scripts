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
    # Lee /etc/passwd para generar los datos de cada usuario.
    # El formato de salida es:
    # sort_key1|sort_key2|sort_key3|USUARIO|SHELL|ESTADO PASS|BLOQUEO|EXPIRACIÓN
    # sort_key1: 0 para shell activo, 1 para no-shell.
    # sort_key2: 0 para UID > 1000, 1 para UID <= 1000.
    # sort_key3: nombre de usuario para orden alfabético.

    awk -F: '$1 != "nobody" {print $1, $3, $7}' /etc/passwd | while read -r user uid shell; do
        local sort_key1
        local sort_key2
        local shell_status
        local password_status
        local locked_status
        local expiry_status

        # Clave 1: Estado del shell
        if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
            sort_key1=1
            shell_status="🔴 NO SHELL"
            password_status="N/A"
            locked_status="N/A"
            expiry_status="N/A"
        else
            sort_key1=0
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
        echo "$user|$shell_status|$password_status|$locked_status|$expiry_status"
    done
}

cs
# Generar el reporte y formatearlo como una tabla bien alineada con 'column'.
generate_report | column -t -s '|' -o ' | '
echo ""