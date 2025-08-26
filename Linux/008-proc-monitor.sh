#!/bin/bash

# =========================================================
# Script para monitorear el uso de recursos de Tomcat.
# Genera un log con el uso de CPU y memoria cada segundo.
# =========================================================

# Define la ubicación del archivo de log.
LOG_FILE="/var/log/tomcat-resource.log"

# Bucle infinito para monitorear continuamente.
while true; do
    # Encuentra el PID de Tomcat. Usamos 'pgrep -f' para buscar
    # el proceso por su línea de comandos completa ("java.*tomcat").
    TOMCAT_PID=$(pgrep -u tomcat java)

    # Verifica si el proceso de Tomcat está corriendo.
    if [ -z "$TOMCAT_PID" ]; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - ADVERTENCIA: Proceso de Tomcat no encontrado." >> "$LOG_FILE"
    else
        # Obtiene el uso de CPU (%) y memoria (%) del PID de Tomcat.
        # --no-headers evita que el comando muestre la cabecera.
        USAGE=$(ps -p "$TOMCAT_PID" -o %cpu,%mem --no-headers)

        # Extrae los valores y los formatea para el log.
        CPU_USAGE=$(echo "$USAGE" | awk '{print $1}')
        MEM_USAGE=$(echo "$USAGE" | awk '{print $2}')

        # Escribe la línea de log con la fecha, PID, CPU y memoria.
        echo "$(date +"%Y-%m-%d %H:%M:%S") - PID: $TOMCAT_PID - CPU: $CPU_USAGE% - MEM: $MEM_USAGE%" >> "$LOG_FILE"
    fi

    # Espera 1 segundo antes de la siguiente iteración.
    sleep 1
done
