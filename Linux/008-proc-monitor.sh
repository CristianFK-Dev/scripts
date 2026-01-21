#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="/var/log/008-proc-monitor.log"
touch "$LOG_DIR"

cs() { clear; }

if [[ $EUID -ne 0 ]]; then
   cs
   echo -e "\n🔐 Este script debe ejecutarse como root (usá sudo)\n"
   exit 1
fi

menu_inicial() {
  cs
  echo -e "\n🧾 008-proc-monitor.sh\n"
  echo -e "¿Qué procesos querés listar?\n"
  echo "  1) Todos los procesos"
  echo "  2) Procesos de sistema (root)"
  echo "  3) Procesos de usuario (UID >= 1000)"
  echo "  l) Ver log"
  echo "  s) Salir"
  echo ""
  read -rp "👉 Opción: " opt

  case "$opt" in
    1) filtro="all" ;;
    2) filtro="system" ;;
    3) filtro="user" ;;
    l) less "$LOG_DIR"; menu_inicial ;;
    s) cs ; echo -e "\n 👋 Saliendo...\n" ; exit 0 ;;
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

  [[ ${#processes[@]} -eq 0 ]] && {
    echo -e "\n❌ No se encontraron procesos."
    read -rp "ENTER para volver..."
    menu_inicial
  }

  echo -e " Nº  PID  UID  CMD"
  printf "%s\n" "${processes[@]}"

  echo -e "\n👉 Elegí procesos por número (ej: 1 14 24), o 'v' para volver:"
  read -rp " Tu elección: " choice

  [[ "$choice" == "v" ]] && menu_inicial

  pairs=()
  for num in $choice; do
    line="${processes[$((num-1))]}"
    pid=$(awk '{print $2}' <<< "$line")
    name=$(awk '{print $4}' <<< "$line")
    pairs+=( "${pid}:${name}" )
  done

  cs
  echo -e "\n⏱️ ¿Cuántos segundos querés monitorear?"
  read -rp " Tiempo: " duration

  echo -e "\n📊 Formato:"
  echo "  1) Resumido (CPU REAL, MEM)"
  echo "  2) Completo (CPU REAL, MEM, RSS, THREADS)"
  read -rp "👉 Opción: " formato

  case "$formato" in
    1) formato="resumido" ;;
    2) formato="completo" ;;
    *) menu_procesos "$filtro" ;;
  esac

  monitorear "$duration" "$formato" "${pairs[@]}"
}

monitorear() {
  local duration="$1"; shift
  local formato="$1"; shift
  local pairs=( "$@" )

  trap 'echo -e "\n⛔ Interrumpido"; read -rp "ENTER..."; menu_inicial' INT

  echo "$(date "+%Y-%m-%d %H:%M:%S") ----INICIO------------------------------------------------" | tee -a "$LOG_DIR"

  for ((i=1; i<=duration; i++)); do
    ts=$(date "+%Y-%m-%d %H:%M:%S")
    for pair in "${pairs[@]}"; do
      pid="${pair%%:*}"
      name="${pair#*:}"

      if ps -p "$pid" &>/dev/null; then
        cpu_real=$(ps -T -p "$pid" -o %cpu= | awk '{sum+=$1} END {printf "%.1f",sum}')
        mem=$(ps -p "$pid" -o %mem=)
        rss=$(ps -p "$pid" -o rss=)
        threads=$(ps -T -p "$pid" | tail -n +2 | wc -l)

        if [[ "$formato" == "resumido" ]]; then
          echo "[$ts] $name (PID $pid) CPU_REAL: ${cpu_real}% MEM: ${mem}%" | tee -a "$LOG_DIR"
        else
          echo "[$ts] $name (PID $pid) CPU_REAL: ${cpu_real}% MEM: ${mem}% RSS: ${rss}KB THREADS: $threads" | tee -a "$LOG_DIR"
        fi
      else
        echo "[$ts] $name (PID $pid) finalizó." | tee -a "$LOG_DIR"
      fi
    done
    sleep 1
  done

  echo "$(date "+%Y-%m-%d %H:%M:%S") ----FIN----------------------------------------------------" | tee -a "$LOG_DIR"
  read -rp "ENTER para volver al menú..."
  menu_inicial
}

menu_inicial
