#!/usr/bin/env bash

set -euo pipefail

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

cs

# Encabezado
printf "%-12s | %-18s | %-18s | %-15s | %-20s\n" "Usuario" "Shell" "Estado Contraseña" "Bloqueo" "Caducidad"
printf "%0.s-" {1..90}; echo

# Listar usuarios con UID <= 1000 excepto nobody
awk -F: '$3 <= 1000 && $1 != "nobody" {print $1, $7}' /etc/passwd | while read -r user shell; do
    if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
        shell_status="NO SHELL"
        password_status="N/A"
        locked_status="N/A"
        expiry_status="N/A"
    else
        shell_status="$shell"
        password_info=$(sudo passwd -S "$user" 2>/dev/null || true)
        if [ -z "$password_info" ]; then
            password_status="NO EXISTE"
            locked_status="N/A"
            expiry_status="N/A"
        else
            password_state=$(echo "$password_info" | awk '{print $2}')
            case "$password_state" in
                "L") password_status="BLOQUEADA";;
                "P") password_status="ACTIVA";;
                "NP") password_status="SIN CONTRASEÑA";;
                *) password_status="$password_state";;
            esac
            locked_status=$(sudo passwd -S "$user" | grep -q "locked" && echo "BLOQUEADA" || echo "DESBLOQUEADA")
            expiry_status=$(sudo chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d ":" -f 2 | xargs)
        fi
    fi

    printf "%-12s | %-18s | %-18s | %-15s | %-20s\n" "$user" "$shell_status" "$password_status" "$locked_status" "$expiry_status"
done
