#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/proc-monitor-logs"
mkdir -p "$LOG_DIR"

cs() { if [ -t 1 ]; then clear; fi; }

menu_procesos() {
  cs
  echo -e "\n🧾 002-proc-monitor.sh\n"
  echo -e "Seleccioná procesos para registrar CPU/MEM por segundo. Logs en: $LOG_DIR\n"

  # Lista de procesos PID + comando (ordenados por nombre)
  mapfile -t processes < <(ps -eo pid,comm --sort=comm | awk 'NR>1 {printf("%s %s\n",$1,$2)}' | nl -w2 -s'. ')
  if [ ${#processes[@]} -eq 0 ]; then
    echo -e "\n❌ No hay procesos.\n"; exit 1
  fi

  echo -e "📋 Procesos (número) PID COMANDO"
  printf "%s\n" "${processes[@]}"

  echo -e "\n👉 Elegí procesos por número (ej: 1 4 7), o 'exit' para salir:"
  read -rp " Tu elección: " choice
  [[ "$choice" == "exit" ]] && echo -e "\n👋 Listo.\n" && exit 0

  pairs=()  # almacenará PID:NOMBRE
  for num in $choice; do
    if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#processes[@]} )); then
      echo -e "\n❌ Número inválido: $num"; sleep 2; menu_procesos
    fi
    line="${processes[$((num-1))]}"
    pid=$(echo "$line"  | awk '{print $2}')
    name=$(echo "$line" | awk '{print $3}')
    pairs+=( "${pid}:${name}" )
  done

  echo -e "\n⏱️ ¿Cuántos segundos querés monitorear?"
  read -rp " Tiempo en segundos: " duration
  if ! [[ "$duration" =~ ^[0-9]+$ ]] || (( duration <= 0 )); then
    echo -e "\n❌ Tiempo inválido."; sleep 2; menu_procesos
  fi

  monitorear "$duration" "${pairs[@]}"
}

monitorear() {
  local duration="$1"; shift
  local pairs=( "$@" )

  trap 'echo -e "\n⛔ Monitoreo interrumpido."; read -rp "ENTER para volver al menú..."; menu_procesos' INT

  echo -e "\n🚀 Monitoreando durante $duration segundos...\n"
  for ((i=1; i<=duration; i++)); do
    ts=$(date "+%Y-%m-%d %H:%M:%S")
    for pair in "${pairs[@]}"; do
      pid="${pair%%:*}"
      name="${pair#*:}"
      if ps -p "$pid" > /dev/null 2>&1; then
        # %cpu %mem rss(KB)
        read -r cpu mem rss <<<"$(ps -p "$pid" -o %cpu= -o %mem= -o rss=)"
        echo "[$ts] $name (PID $pid) CPU: ${cpu}% MEM: ${mem}% RSS: ${rss} KB" \
          | tee -a "$LOG_DIR/${name}_${pid}.log"
      else
        echo "[$ts] $name (PID $pid) finalizó." \
          | tee -a "$LOG_DIR/${name}_${pid}.log"
      fi
    done
    sleep 1
  done

  echo -e "\n✅ Monitoreo finalizado. Ver logs en $LOG_DIR\n"
  read -rp "ENTER para volver al menú..."
  menu_procesos
}

menu_procesos
