#!/usr/bin/env bash

set -euo pipefail

cs() {
    clear
}

if [[ $EUID -ne 0 ]]; then
   cs
   echo -e "\n🔐 Este script debe ejecutarse como root (usá sudo)\n"
   exit 1
fi

cs
echo -e "._______________________________________________________________________________________________________."
echo -e "| 🛠️  007-service-systemd-inactive.sh                                                                  |"
echo -e "| Este script lista los servicios INACTIVOS de systemd y permite gestionarlos                           |"
echo -e "| de forma interactiva. Podrás iniciar o ver el estado detallado                                        |"
echo -e "| del servicio que elijas del menú.                                                                     |"
echo -e "|_______________________________________________________________________________________________________|\n"
read -rp "Presioná ENTER para continuar..."

temp_list_file=""
trap 'rm -f "$temp_list_file"' EXIT

while true; do
    cs
    services=()
    descriptions=()
    while IFS='|' read -r service_name service_desc; do
        services+=("$service_name")
        if [[ -z "$service_desc" ]]; then
            descriptions+=("-- Sin descripción --")
        else
            descriptions+=("$service_desc")
        fi
    done < <(systemctl list-units --type=service --state=inactive --no-legend --full | awk '{name=$1; $1=$2=$3=$4=""; sub(/^[ \t]+/, ""); print name"|"substr($0, 1)}')

    if [ ${#services[@]} -eq 0 ]; then
        echo -e "\n✅ No se encontraron servicios inactivos.\n"
        exit 0
    fi

    echo -e "--- Servicios Inactivos (no están corriendo) ---\n"

    temp_list_file=$(mktemp)

    echo "N°|SERVICIO|DESCRIPCIÓN" > "$temp_list_file"
    for i in "${!services[@]}"; do
        printf "%d|%s|%s\n" "$((i+1))" "${services[$i]}" "${descriptions[$i]}" >> "$temp_list_file"
    done

    column -t -s '|' -o ' | ' "$temp_list_file"
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
    echo -e "🔧 Acciones para el servicio inactivo: \e[1;33m$service\e[0m\n"
    echo -e "   1) \e[1;33mVer Estado (status)\e[0m"
    echo -e "   2) \e[1;32mIniciar (start)\e[0m"
    echo -e "   3) Volver a la lista"
    echo ""
    read -rp "   Tu elección: " action_choice

    case "$action_choice" in
        1)
            cs
            echo -e "🔎 Mostrando estado de '\e[1;33m$service\e[0m'...\n"
            systemctl status "$service" || true
            ;;
        2)
             cs
            echo -e "🚀 Iniciando el servicio '\e[1;33m$service\e[0m'..."
            systemctl start "$service"
            echo -e "\n✅ Servicio iniciado."
            ;;
        3)
            continue
            ;;
        *)
            echo -e "\n❌ Opción no válida."
            ;;
    esac

    echo ""
    read -rp "Presioná ENTER para volver a la lista..."
    rm -f "$temp_list_file" 
done