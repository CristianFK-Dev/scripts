#!/usr/bin/env bash

set -euo pipefail

# --- Variables de Color ---
C_GREEN='\033[1;32m'
C_RED='\033[1;31m'
C_YELLOW='\033[1;33m'
C_ORANGE='\033[38;5;208m'
C_NC='\033[0m' # Sin Color

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

cs
echo -e "\n🛠️  gestionar-servicios.sh\n"
echo -e "Este script presenta un menú para gestionar servicios activos o inactivos."
echo -e "Podrás iniciar, detener, reiniciar y ver el estado de los servicios."
echo -e "el servicio que elijas del menú.\n"
read -rp "Presioná ENTER para continuar..."
cs

if [[ $EUID -ne 0 ]]; then
   echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
   exit 1
fi

manage_services() {
    local state=$1
    local title_state=$2

    while true; do
        cs
        echo -e "--- Servicios ${title_state} ---\n"

        mapfile -t services < <(systemctl list-units --type=service --state="$state" --no-legend --plain | awk '{print $1}')

        if [ ${#services[@]} -eq 0 ]; then
            echo -e "\n✅ No se encontraron servicios en estado '${state}'.\n"
            read -rp "Presioná ENTER para volver al menú principal..."
            return
        fi

        numbered_services=()
        for i in "${!services[@]}"; do
            numbered_services+=("$(printf "%3d) %s" "$((i+1))" "${services[$i]}")")
        done
        
        printf "%s\n" "${numbered_services[@]}"
        echo ""
        
        printf "👉 Elige un servicio por su número o escribe [${C_ORANGE}v${C_NC}] para volver: "
        read -r choice

        case "$choice" in
            v|V|volver)
                return
                ;;
        esac

        if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#services[@]} )); then
            echo -e "\n❌ Opción no válida. Inténtalo de nuevo."
            sleep 2
            continue
        fi

        service="${services[$((choice-1))]}"

        cs
        echo -e "\n🔧 Acciones para el servicio: ${C_YELLOW}$service${C_NC}\n"

        if [[ "$state" == "active" ]]; then
            echo -e "   1) ${C_GREEN}Ver Estado (status)${C_NC}"
            echo -e "   2) ${C_RED}Detener (stop)${C_NC}"
            echo -e "   3) ${C_YELLOW}Reiniciar (restart)${C_NC}"
            echo "   4) Volver a la lista"
            read -rp "   Tu elección: " action_choice

            case "$action_choice" in
                1) cs; echo -e "🔎 Mostrando estado de '${C_YELLOW}$service${C_NC}'...\n"; systemctl --no-pager status "$service";;
                2) cs; echo -e "🛑 Deteniendo el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl stop "$service"; echo -e "\n${C_GREEN}✅ Servicio detenido.${C_NC}";;
                3) cs; echo -e "🔄 Reiniciando el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl restart "$service"; echo -e "\n${C_GREEN}✅ Servicio reiniciado.${C_NC}";;
                4) continue;;
                *) echo -e "\n❌ Opción no válida.";;
            esac
        else # inactive, failed, etc.
            echo -e "   1) ${C_GREEN}Ver Estado (status)${C_NC}"
            echo -e "   2) ${C_GREEN}Iniciar (start)${C_NC}"
            echo "   3) Volver a la lista"
            read -rp "   Tu elección: " action_choice

            case "$action_choice" in
                1) cs; echo -e "🔎 Mostrando estado de '${C_YELLOW}$service${C_NC}'...\n"; systemctl --no-pager status "$service";;
                2) cs; echo -e "🚀 Iniciando el servicio '${C_YELLOW}$service${C_NC}'..."; systemctl start "$service"; echo -e "\n${C_GREEN}✅ Servicio iniciado.${C_NC}";;
                3) continue;;
                *) echo -e "\n❌ Opción no válida.";;
            esac
        fi

        echo ""
        read -rp "Presioná ENTER para volver a la lista de servicios..."
    done
}

# --- Bucle Principal del Menú ---
while true; do
    cs
    echo -e "--- Gestor de Servicios Systemd ---\n"
    echo -e "Elige qué tipo de servicios quieres gestionar:\n"
    echo -e "   1) Servicios ${C_GREEN}ACTIVOS${C_NC} (para detener o reiniciar)"
    echo -e "   2) Servicios ${C_RED}INACTIVOS${C_NC} (para iniciar)"
    echo -e "   3) Salir"
    echo ""
    read -rp "   Tu elección: " main_choice

    case "$main_choice" in
        1)
            manage_services "active" "ACTIVOS"
            ;;
        2)
            # Podemos incluir más estados si queremos, ej: "inactive failed"
            manage_services "inactive" "INACTIVOS"
            ;;
        3)
            cs
            echo -e "\n👋 Saliendo del gestor de servicios.\n"
            exit 0
            ;;
        *)
            echo -e "\n❌ Opción no válida. Inténtalo de nuevo."
            sleep 2
            ;;
    esac
done