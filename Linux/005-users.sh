#!/usr/bin/env bash

set -euo pipefail

if [ -t 1 ]; then
    clear
fi

awk -F: '$3 <= 1000 && $1 != "nobody" {print $1, $7}' /etc/passwd | while read user shell; do
    # Verificar tipo de shell
    if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
        shell_status="🔴 NO SHELL"
        password_status="N/A"
        locked_status="N/A"
        expiry_status="N/A"
    else
        shell_status="🟢 SHELL: $shell"
        # Verificar estado de contraseña (usando passwd -S)
        password_info=$(sudo passwd -S "$user" 2>/dev/null)
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
            # Verificar si está bloqueada por pam_tally2 o faillock
            locked_status=$(sudo passwd -S "$user" | grep -q "locked" && echo "🔐 BLOQUEADA" || echo "✅ DESBLOQUEADA")
            # Obtener caducidad (chage)
            expiry_status=$(sudo chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d ":" -f 2 | xargs)
        fi
    fi
    # Formatear salida
    printf "%-8s | %-12s | %-10s | %-9s | %s\n" "$user" "$shell_status" "$password_status" "$locked_status" "$expiry_status"
done