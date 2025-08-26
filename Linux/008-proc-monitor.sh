#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$HOME/proc-monitor-logs"
mkdir -p "$LOG_DIR"

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

menu_procesos() {
    cs
    echo -e "\n🧾 002-proc-monitor.sh\n"
    echo -e "Este script permite seleccionar procesos y registrar su consumo de CPU y memoria."
    echo -e "Los datos se guardan en $LOG_DIR.\n"

    # Listar procesos activos
    mapfile -t processes < <(ps -eo pid,comm --sort=comm | awk 'NR>1 {print $1, $2}' | nl -w2 -s'. ')

    if [ ${#processes[@]} -eq 0 ]; then
        echo -e "\n❌ No hay procesos activos.\n"
        exit 1
    fi

    echo -e "\n📋 Procesos activos (PID y nombre):"
    printf "%s\n" "${processes[@]}"

    # Selección
    echo -e "\n👉 Ingresá los números de los procesos a monitorear (ej: 1 4 7), o 'exit' para salir:"
    read -rp " Tu elección: " choice

    if [[ "$choice" == "exit" ]]; then
        echo -e "\n👋 Saliendo sin hacer cambios.\n"
        exit 0
    fi

    pids=()
    names=()

    for num in $choice; do
        if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#processes[@]} )); then
            echo -e "\n❌ Número inválido: $num"
            sleep 2
            menu_procesos
        fi
        line="${processes[$((num-1))]}"
        pid=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | awk '{print $3}')
        pids+=( "$pid" )
        names+=( "$name" )
    done

    # Tiempo de monitoreo
    echo -e "\n⏱️ ¿Cuántos segundos querés monitorear?"
    read -rp " Tiempo en segundos: " duration
    if ! [[ "$duration" =~ ^[0-9]+$ ]] || (( duration <= 0 )); then
        echo -e "\n❌ Tiempo inválido."
        sleep 2
        menu_procesos
    fi

    monitorear "${pids[@]}" "${names[@]}" "$duration"
}

monitorear() {
    local pids=()
    local names=()
    local duration="$1"
    shift
    # Trick: dividir arrays
    while [[ $# -gt 0 ]]; do
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            pids+=( "$1" )
        else
            names+=( "$1" )
        fi
        shift
    done

    echo -e "\n🚀 Monitoreando procesos seleccionados durante $duration segundos...\n"

    for ((i=1; i<=duration; i++)); do
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        for j in "${!pids[@]}"; do
            pid="${pids[$j]}"
            name="${names[$j]}"
            if ps -p "$pid" > /dev/null 2>&1; then
                stats=$(ps -p "$pid" -o %cpu,%mem,rss --no-headers)
                cpu=$(echo "$stats" | awk '{print $1}')
                mem=$(echo "$stats" | awk '{print $2}')
                rss=$(echo "$stats" | awk '{print $3}')
                echo "[$timestamp] $name (PID $pid) CPU: ${cpu}% MEM: ${mem}% RSS: ${rss} KB" \
                    | tee -a "$LOG_DIR/${name}_${pid}.log"
            else
                echo "[$timestamp] $name (PID $pid) finalizó." \
                    | tee -a "$LOG_DIR/${name}_${pid}.log"
            fi
        done
        sleep 1
    done

    echo -e "\n✅ Monitoreo finalizado. Logs guardados en $LOG_DIR\n"
    read -rp "Presioná ENTER para volver al menú..."
    menu_procesos
}

# Iniciar menú
menu_procesos