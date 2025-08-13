#!/usr/bin/env bash

# Configuramos el script para que sea estricto y falle ante errores.
set -euo pipefail

# Función para limpiar la pantalla si es una terminal interactiva.
cs() {
    if [ -t 1 ]; then
        clear
    fi
}

# --- Bienvenida y Documentación ---
cs
echo -e "\n🛠️  gestionar-servicios.sh\n"
echo -e "Este script lista los servicios activos de systemd y permite gestionarlos"
echo -e "de forma interactiva. Podrás ver el estado, detener o reiniciar"
echo -e "el servicio que elijas del menú.\n"
read -rp "Presioná ENTER para continuar..."
cs

# --- Verificación de Permisos ---
if [[ $EUID -ne 0 ]]; then
   echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n" 
   exit 1
fi

# --- Obtención de Datos ---
# Usamos mapfile para cargar los nombres de los servicios activos en un array.
# --no-legend evita la línea de cabecera de systemctl.
mapfile -t services < <(systemctl list-units --type=service --state=active --no-legend | awk '{print $1}')

if [ ${#services[@]} -eq 0 ]; then
    echo -e "\n✅ No se encontraron servicios activos.\n"
    exit 0
fi

# --- Menú Interactivo Principal ---
# PS3 es el prompt que mostrará el menú `select`.
PS3="👉 Elige un servicio (o el número de 'Salir') para ver opciones: "

# El bucle `select` muestra los servicios y espera una elección.
# Añadimos una opción "Salir" al final del array de servicios.
select service in "${services[@]}" "Salir"; do
    # Si la elección es "Salir", rompemos el bucle y terminamos.
    if [[ "$service" == "Salir" ]]; then
        cs
        echo -e "\n👋 Saliendo del gestor de servicios.\n"
        break
    fi

    # Si la elección es un número válido, pero el contenido está vacío (error), avisamos.
    if [[ -z "$service" ]]; then
        echo -e "\n❌ Opción no válida. Inténtalo de nuevo."
        continue
    fi
    
    # --- Submenú de Acciones para el Servicio Seleccionado ---
    cs
    echo -e "\n🔧 Acciones para el servicio: \e[1;33m$service\e[0m\n" # Pone el nombre en amarillo
    
    # Presentamos las opciones para el servicio elegido.
    echo "   1) Ver Estado (status)"
    echo "   2) Detener (stop)"
    echo "   3) Reiniciar (restart)"
    echo "   4) Volver al menú principal"
    
    read -rp "   Tu elección: " action_choice

    case "$action_choice" in
        1)
            cs
            echo -e "🔎 Mostrando estado de '\e[1;33m$service\e[0m'...\n"
            # Ejecutamos el comando de estado. No usamos `sudo` aquí porque ya somos root.
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
            cs # Limpiamos la pantalla para volver a mostrar el menú principal.
            echo "↩️  Volviendo al listado de servicios..."
            # `continue` salta al siguiente ciclo del bucle `select`, mostrando el menú de nuevo.
            continue
            ;;
        *)
            echo -e "\n❌ Opción no válida."
            ;;
    esac

    echo ""
    read -rp "Presioná ENTER para volver al menú principal..."
    cs # Limpiamos la pantalla antes de que `select` vuelva a dibujar el menú.
done