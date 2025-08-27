#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="/var/log/proc-monitor.log"
echo "##### Archivos de registro de monitoreo de procesos script 008-proc-monitor #####" >> "$LOG_DIR"
touch "$LOG_DIR"

cs() {
  if [ -t 1 ]; then clear; fi;
}

menu_inicial() {
  cs
  echo -e "\n🧾 008-proc-monitor.sh\n"
  echo -e "¿Qué procesos querés listar?\n"
  echo "  1) Todos los procesos"
  echo "  2) Procesos de sistema (root)"
  echo "  3) Procesos de usuario (UID >= 1000)"
  echo "  s) Salir"
  echo ""
  read -rp "👉 Opción: " opt

  case "$opt" in
    1) filtro="all" ;;
    2) filtro="system" ;;
    3) filtro="user" ;;
    s) echo -e "\n👋 Saliendo...\n"; exit 0 ;;
    *) echo -e "\n❌ Opción inválida"; sleep 2; menu_inicial ;;
  esac

  menu_procesos "$filtro"
}

menu_procesos() {
  local filtro="$1"
  cs
  echo -e "\n📋 Selección de procesos ($filtro)\n"

  case "$filtro" in
    all) 
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 {printf("%s %s %s\n",$1,$2,$3)}' | nl -w2 -s'. ')
      ;;
    system)
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 && $2==0 {printf("%s %s %s\n",$1,$2,$3)}' | nl -w2 -s'. ')
      ;;
    user)
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 && $2>=1000 {printf("%s %s %s\n",$1,$2,$3)}' | nl -w2 -s'. ')
      ;;
  esac

  if [ ${#processes[@]} -eq 0 ]; then
    echo -e "\n❌ No se encontraron procesos para esta categoría."
    read -rp "ENTER para volver al menú inicial..."
    menu_inicial
  fi

  echo -e " Nº  PID  UID  CMD"
  printf "%s\n" "${processes[@]}"

  echo -e "\n👉 Elegí procesos por número (ej: 1 14 24), o 'v' para volver:"
  read -rp " Tu elección: " choice
  
  [[ "$choice" == "v" ]] && menu_inicial

  pairs=()  # almacenará PID:NOMBRE
  for num in $choice; do
    if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#processes[@]} )); then
      echo -e "\n❌ Número inválido: $num"; sleep 2; menu_procesos "$filtro"
    fi
    line="${processes[$((num-1))]}"
    pid=$(echo "$line"  | awk '{print $2}')
    name=$(echo "$line" | awk '{print $4}')
    pairs+=( "${pid}:${name}" )
  done
  cs
  echo -e "\n✅ Procesos seleccionados:"
  printf "%s\n" "👉 ${pairs[@]}"
  echo -e "\n⏱️ ¿Cuántos segundos querés monitorear?"
  read -rp " Tiempo en segundos: " duration

  if ! [[ "$duration" =~ ^[0-9]+$ ]] || (( duration <= 0 )); then
    echo -e "\n❌ Tiempo inválido."; sleep 2; menu_procesos "$filtro"
  fi
  echo -e "\n📊 ¿Qué formato preferís?"
  echo "  1) Resumido (PID, CPU, MEM)"
  echo "  2) Completo (PID, CPU, MEM, RSS, CMD)"
  read -rp "👉 Formato: " formato
  cs
  case "$formato" in
    1) formato="resumido" ;;
    2) formato="completo" ;;
    *) echo -e "\n❌ Opción inválida"; sleep 2; menu_procesos "$filtro" ;;
  esac

  monitorear "$duration" "$formato" "${pairs[@]}"
}

monitorear() {
  local duration="$1"; shift
  local formato="$1"; shift
  local pairs=( "$@" )

  trap 'echo -e "\n⛔ Monitoreo interrumpido."; read -rp "ENTER para volver al menú inicial..."; menu_inicial' INT

  echo -e "\n🚀 Monitoreando durante $duration segundos...\n"
  for ((i=1; i<=duration; i++)); do
    ts=$(date "+%Y-%m-%d %H:%M:%S")
    for pair in "${pairs[@]}"; do
      pid="${pair%%:*}"
      name="${pair#*:}"
      if ps -p "$pid" > /dev/null 2>&1; then
        read -r cpu mem rss cmdline <<<"$(ps -p "$pid" -o %cpu= -o %mem= -o rss= -o args=)"
        if [ "$formato" = "resumido" ]; then
          echo "[$ts] $name (PID $pid) CPU: ${cpu}% MEM: ${mem}%" | tee -a "$LOG_DIR"
        else
          echo "[$ts] $name (PID $pid) CPU: ${cpu}% MEM: ${mem}% RSS: ${rss} KB CMD: ${cmdline}" | tee -a "$LOG_DIR"
        fi
      else
        echo "[$ts] $name (PID $pid) finalizó." | tee -a "$LOG_DIR"
      fi
    done
    sleep 1
  done
  echo "----------------------------------------------------------------------------------------------------------" | tee -a "$LOG_DIR"
  echo -e "\n✅ Monitoreo finalizado. Ver logs en $LOG_DIR\n"
  read -rp "ENTER para volver al menú inicial..."
  menu_inicial
}

menu_inicial
