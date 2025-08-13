#!/usr/bin/env bash

set -euo pipefail

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

cs
echo -e "\n🛠️  gestionar-servicios.sh\n"
echo -e "Este script lista los servicios activos de systemd y permite gestionarlos"
echo -e "de forma interactiva. Podrás ver el estado, detener o reiniciar"
echo -e "el servicio que elijas del menú.\n"
read -rp "Presioná ENTER para continuar..."
cs

if [[ $EUID -ne 0 ]]; then
   echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n" 
   exit 1
fi


mapfile -t services < <(systemctl list-units --type=service --state=active --no-legend | awk '{print $1}')

if [ ${#services[@]} -eq 0 ]; then
    echo -e "\n✅ No se encontraron servicios activos.\n"
    exit 0
fi

while true; do
    cs
    echo -e "Servicios activos:\n"
    
    numbered_services=()
    for i in "${!services[@]}"; do
        numbered_services+=("$(printf "%3d) %s" "$((i+1))" "${services[$i]}")")
    done
    
    printf "%s\n" "${numbered_services[@]}" | column -c "$(tput cols)"
    echo ""
    
    printf "👉 Elige un servicio por su número o escribe \e[38;5;208m[s] para salir\e[0m: "
    read -r choice

    case "$choice" in
        s|S|salir)
            cs
            echo -e "\n👋 Saliendo del gestor de servicios.\n"
            break
            ;;
    esac

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#services[@]} )); then
        echo -e "\n❌ Opción no válida. Inténtalo de nuevo."
        sleep 2
        continue
    fi

    service="${services[$((choice-1))]}"

    cs
    echo -e "\n🔧 Acciones para el servicio: \e[1;33m$service\e[0m\n" 
    echo -e "   1) \e[1;32mVer Estado (status)\e[0m"
    echo -e "   2) \e[1;31mDetener (stop)\e[0m"
    echo -e "   3) \e[1;33mReiniciar (restart)\e[0m"
    echo "   4) Volver al menú principal"

    read -rp "   Tu elección: " action_choice

    case "$action_choice" in
        1)
            cs
            echo -e "🔎 Mostrando estado de '\e[1;33m$service\e[0m'...\n"
            systemctl status "$service"
            ;;
        2)
            cs
            echo -e "🛑 Deteniendo el servicio '\e[1;33m$service\e[0m'..."
            systemctl stop "$service"
            echo -e "\n✅ Servicio detenido."
            ;;
        3)
            cs
            echo -e "🔄 Reiniciando el servicio '\e[1;33m$service\e[0m'..."
            systemctl restart "$service"
            echo -e "\n✅ Servicio reiniciado."
            ;;
        4)
            continue
            ;;
        *)
            echo -e "\n❌ Opción no válida."
            ;;
    esac

    echo ""
    read -rp "Presioná ENTER para volver al menú principal..."
done