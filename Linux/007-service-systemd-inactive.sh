#!/usr/bin/env bash

set -euo pipefail

# Función para limpiar la pantalla si es una terminal interactiva
cs() {
    if [ -t 1 ]; then
        clear
    fi
}

# --- Bienvenida e Instrucciones ---
cs
echo -e "\nðŸ›  007-service-inactive-manager.sh\n"
echo -e "Este script lista los servicios INACTIVOS de systemd y permite gestionarlos"
echo -e "de forma interactiva. PodrÃ¡s iniciar o ver el estado detallado"
echo -e "del servicio que elijas del menÃº.\n"
read -rp "PresionÃ¡ ENTER para continuar..."

# --- VerificaciÃ³n de permisos de root ---
if [[ $EUID -ne 0 ]]; then
   cs
   echo -e "\nðŸ”’ Este script debe ejecutarse como root (usÃ¡ sudo)\n"
   exit 1
fi

# --- Bucle Principal ---
while true; do
    cs
    # Obtener la lista de servicios inactivos cada vez que se muestra el menÃº
    # para reflejar los cambios (ej. un servicio que se iniciÃ³ ya no aparecerÃ¡)
    mapfile -t services < <(systemctl list-units --type=service --state=inactive --no-legend | awk '{print $1}')

    if [ ${#services[@]} -eq 0 ]; then
        echo -e "\nâœ… No se encontraron servicios inactivos.\n"
        exit 0
    fi

    echo -e "--- Servicios Inactivos ---\n"

    # Preparar la lista numerada para mostrarla en columnas
    numbered_services=()
    for i in "${!services[@]}"; do
        numbered_services+=("$(printf "%4d) %s" "$((i+1))" "${services[$i]}")")
    done

    # Mostrar la lista en columnas que se ajustan al ancho de la terminal
    printf "%s\n" "${numbered_services[@]}" | column -c "$(tput cols)"
    echo ""

    # --- MenÃº de SelecciÃ³n de Servicio ---
    printf "ðŸ‘‰ Elige un servicio por su nÃºmero o escribe \e[38;5;208m[s] para salir\e[0m: "
    read -r choice

    case "$choice" in
        s|S|salir)
            cs
            echo -e "\nðŸ‘‹ Saliendo del gestor de servicios.\n"
            break
            ;;
    esac

    # Validar que la entrada sea un nÃºmero dentro del rango vÃ¡lido
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#services[@]} )); then
        echo -e "\nâŒ OpciÃ³n no vÃ¡lida. IntÃ©ntalo de nuevo."
        sleep 2
        continue
    fi

    # Obtener el nombre del servicio seleccionado
    service="${services[$((choice-1))]}"

    # --- MenÃº de Acciones para el Servicio Seleccionado ---
    cs
    echo -e "ðŸ”§ Acciones para el servicio inactivo: \e[1;33m$service\e[0m\n"
    echo -e "   1) \e[1;32mIniciar (start)\e[0m"
    echo -e "   2) \e[1;33mVer Estado (status)\e[0m"
    echo -e "   3) Volver a la lista"
    echo ""
    read -rp "   Tu elecciÃ³n: " action_choice

    case "$action_choice" in
        1)
            cs
            echo -e "ðŸš€ Iniciando el servicio '\e[1;33m$service\e[0m'..."
            systemctl start "$service"
            echo -e "\nâœ… Servicio iniciado."
            ;;
        2)
            cs
            echo -e "ðŸ”Ž Mostrando estado de '\e[1;33m$service\e[0m'...\n"
            systemctl status "$service"
            ;;
        3)
            continue
            ;;
        *)
            echo -e "\nâŒ OpciÃ³n no vÃ¡lida."
            ;;
    esac

    echo ""
    read -rp "PresionÃ¡ ENTER para volver a la lista..."
done