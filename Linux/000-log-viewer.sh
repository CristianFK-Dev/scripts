#!/usr/bin/env bash

set -euo pipefail

cs() {
    clear
}

cs
echo -e " .______________________________________________________________________________________________________."
echo -e " | 🧾 000-log-visor.sh                                                                                 |"                                                                            
echo -e " | Este script permite visualizar y monitorear archivos de log en tiempo real.                          |"
echo -e " | Podés elegir uno o varios logs por número, o ver todos.                                             |"
echo -e " |______________________________________________________________________________________________________|\n"
read -rp " Presioná ENTER para continuar..." 

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"
RESET="\e[0m"

if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔐 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

check_dependencies() {
    if ! command -v multitail &>/dev/null; then
        echo -e "\n❌ multitail no está instalado"
        read -rp "¿Querés instalarlo? [s/N]: " install
        if [[ "${install,,}" =~ ^(s|si|y|yes)$ ]]; then
            apt update && apt install -y multitail
        else
            echo -e "\n❌ multitail es necesario para ejecutar este script"
            exit 1
        fi
    fi
}

get_logs() {
    mapfile -t logs < <(find /var/log -type f -name "*.log" -o -name "syslog" | sort)
}

show_log_menu() {
    cs
    echo -e "\n📋 Logs disponibles:\n"
    for i in "${!logs[@]}"; do
        echo -e "${CYAN}$((i+1))${RESET}) ${logs[$i]}"
    done
    echo -e "\n${YELLOW}s${RESET}) 🚪 Salir"
}

main() {
    check_dependencies
    get_logs

    while true; do
        show_log_menu
        echo -e "\n👉 ¿Cuántos logs querés ver? (1-4):"
        read -rp "Cantidad: " num_logs

        if [[ "$num_logs" == "s" ]]; then
            cs
            echo -e "\n👋 ¡Hasta luego!\n"
            exit 0
        fi

        if ! [[ "$num_logs" =~ ^[1-4]$ ]]; then
            echo -e "\n❌ Ingresá un número entre 1 y 4"
            sleep 2
            continue
        fi

        selected_logs=()
        echo -e "\n👉 Elegí los logs por número (ej: 1 3 5):"
        read -ra choices

        if [[ ${#choices[@]} -ne $num_logs ]]; then
            echo -e "\n❌ Debés elegir exactamente $num_logs logs"
            sleep 2
            continue
        

        for choice in "${choices[@]}"; do
            if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
               (( choice < 1 || choice > ${#logs[@]} )); then
                echo -e "\n❌ Selección inválida: $choice"
                sleep 2
                continue 2
            fi
            selected_logs+=("${logs[$((choice-1))]}")
        done

        # Construct multitail command
        cmd="multitail"
        for log in "${selected_logs[@]}"; do
            cmd+=" -ci green $log"
        done

        cs
        echo -e "\n🔍 Monitoreando logs seleccionados..."
        echo -e "📌 Presioná Ctrl+C para volver al menú\n"
        sleep 2
        eval "$cmd"
}

main