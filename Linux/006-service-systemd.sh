#!/usr/bin/env bash

set -euo pipefail

# --- Variables de Color ---
C_GREEN='\e[1;32m'
C_RED='\e[1;31m'
C_YELLOW='\e[1;33m'
C_ORANGE='\e[38;5;208m'
C_NC='\e[0m' # Sin Color

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

cs
echo -e "\n🛠️  gestionar-servicios.sh\n"
echo -e "Este script lista los servicios activos e inactivos de systemd y permite gestionarlos"
echo -e "de forma interactiva. Podrás ver el estado, iniciar, detener o reiniciar"
echo -e "el servicio que elijas del menú.\n"
read -rp "Presioná ENTER para continuar..."
cs

if [[ $EUID -ne 0 ]]; then
   echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
   exit 1
fi

while true; do
    cs
    echo -e "Servicios del sistema (systemd):\n"

    # Obtenemos todos los servicios cargados (activos, inactivos, etc.)
    # Guardamos el nombre del servicio y su estado (ej: ssh.service active)
    mapfile -t services_data < <(systemctl list-units --type=service --all --no-legend | awk '{print $1, $3}')

    if [ ${#services_data[@]} -eq 0 ]; then
        echo -e "\n❌ No se encontraron servicios para gestionar.\n"
        exit 1
    fi

    # Preparamos los arrays para el menú
    services=()
    numbered_services=()
    for i in "${!services_data[@]}"; do
        read -r name state <<< "${services_data[$i]}"
        services+=("$name") # Array solo con nombres para facilitar la selección

        # Asignar color según el estado
        if [[ "$state" == "active" ]]; then
            status_colored="(${C_GREEN}activo${C_NC})"
        else
            status_colored="(${C_RED}${state}${C_NC})"
        fi
        
        # Formatear la línea para el menú
        numbered_services+=("$(printf "%3d) %-40s %s" "$((i+1))" "$name" "$status_colored")")
    done
    
    printf "%s\n" "${numbered_services[@]}" | column -c "$(tput cols)"
    echo ""
    
    printf "👉 Elige un servicio por su número o escribe [${C_ORANGE}s${C_NC}] para salir: "
    read -r choice

    case "$choice" in
        s|S|salir)
            cs
            echo -e "\n👋 Saliendo del gestor de servicios.\n"
            exit 0
            ;;
    esac

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#services[@]} )); then
        echo -e "\n❌ Opción no válida. Inténtalo de nuevo."
        sleep 2
        continue
    fi

    # Obtenemos el nombre y el estado del servicio seleccionado
    service_line="${services_data[$((choice-1))]}"
    read -r service state <<< "$service_line"

    cs
    echo -e "\n🔧 Acciones para el servicio: ${C_YELLOW}$service${C_NC}\n"

    # Menú dinámico según el estado del servicio
    if [[ "$state" == "active" ]]; then
        echo -e "   1) ${C_GREEN}Ver Estado (status)${C_NC}"
        echo -e "   2) ${C_RED}Detener (stop)${C_NC}"
        echo -e "   3) ${C_YELLOW}Reiniciar (restart)${C_NC}"
        echo "   4) Volver al menú principal"
        read -rp "   Tu elección: " action_choice

        case "$action_choice" in
            1) cs; echo -e "🔎 Mostrando estado de '${C_YELLOW}$service${C_NC}'...\n"; systemctl status "$service";;
            2) cs; echo -e "🛑 Deteniendo el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl stop "$service"; echo -e "\n${C_GREEN}✅ Servicio detenido.${C_NC}";;
            3) cs; echo -e "🔄 Reiniciando el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl restart "$service"; echo -e "\n${C_GREEN}✅ Servicio reiniciado.${C_NC}";;
            4) continue;;
            *) echo -e "\n❌ Opción no válida.";;
        esac
    else # El servicio está inactivo, fallido, etc.
        echo -e "   1) ${C_GREEN}Ver Estado (status)${C_NC}"
        echo -e "   2) ${C_GREEN}Iniciar (start)${C_NC}"
        echo "   3) Volver al menú principal"
        read -rp "   Tu elección: " action_choice

        case "$action_choice" in
            1) cs; echo -e "🔎 Mostrando estado de '${C_YELLOW}$service${C_NC}'...\n"; systemctl status "$service";;
            2) cs; echo -e "🚀 Iniciando el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl start "$service"; echo -e "\n${C_GREEN}✅ Servicio iniciado.${C_NC}";;
            3) continue;;
            *) echo -e "\n❌ Opción no válida.";;
        esac
    fi

    echo ""
    read -rp "Presioná ENTER para volver al menú principal..."
done