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

ITEMS_PER_PAGE=20
current_page=1
total_services=${#services[@]}
total_pages=$(( (total_services + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE ))

while true; do
    cs
    echo -e "Servicios activos (Página $current_page/$total_pages):\n"
    
    start_index=$(( (current_page - 1) * ITEMS_PER_PAGE ))
    end_index=$(( start_index + ITEMS_PER_PAGE - 1 ))
    if (( end_index >= total_services )); then
        end_index=$(( total_services - 1 ))
    fi

    for i in $(seq $start_index $end_index); do
        printf "   %3d) %s\n" "$((i+1))" "${services[$i]}"
    done
    
    echo ""
    
    nav_prompt="👉 Elige un servicio"
    if (( total_pages > 1 )); then
        nav_prompt+=", [n]ext, [p]rev,"
    fi
    nav_prompt+=" o [s]alir: "
    
    read -rp "$nav_prompt" choice

    case "$choice" in
        n|N)
            if (( current_page < total_pages )); then ((current_page++)); fi
            continue
            ;;
        p|P)
            if (( current_page > 1 )); then ((current_page--)); fi
            continue
            ;;
        s|S|salir)
            cs
            echo -e "\n👋 Saliendo del gestor de servicios.\n"
            break
            ;;
    esac

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > total_services )); then
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