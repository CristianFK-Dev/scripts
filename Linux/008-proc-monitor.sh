#!/usr/bin/env bash

# Mejoras Logs
# En los logs tendria que tener una lista de los PID y el nombre del proceso antes del inicio del log

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
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 {printf("%-10s %-10s %s\n",$1,$2,$3)}' | nl -w3 -s'. ')
      ;;
    system)
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 && $2==0 {printf("%-10s %-10s %s\n",$1,$2,$3)}' | nl -w3 -s'. ')
      ;;
    user)
      mapfile -t processes < <(ps -eo pid,uid,comm --sort=comm | awk 'NR>1 && $2>=1000 {printf("%-10s %-10s %s\n",$1,$2,$3)}' | nl -w3 -s'. ')
      ;;
  esac

  [[ ${#processes[@]} -eq 0 ]] && {
    echo -e "\n❌ No se encontraron procesos."
    read -rp "ENTER para volver..."
    menu_inicial
  }

  echo -e "  Nº PID        UID        CMD"
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

  # Detectar CLK_TCK para cálculo preciso de CPU (fallback 100)
  local clk_tck
  clk_tck=$(getconf CLK_TCK 2>/dev/null || echo 100)

  # Arrays asociativos para guardar estado previo
  declare -A prev_ticks
  declare -A prev_time

  # Toma de datos inicial para calcular el delta
  for pair in "${pairs[@]}"; do
    local pid="${pair%%:*}"
    if [[ -f "/proc/$pid/stat" ]]; then
      local content right stats
      content=$(< "/proc/$pid/stat")
      right="${content##*)}"
      read -r -a stats <<< "$right"
      # utime (idx 11) + stime (idx 12)
      prev_ticks[$pid]=$(( ${stats[11]} + ${stats[12]} ))
      prev_time[$pid]=$(date +%s.%N)
    fi
  done

  echo "$(date "+%Y-%m-%d %H:%M:%S") ----INICIO------------------------------------------------" | tee -a "$LOG_DIR"

  for ((i=1; i<=duration; i++)); do
    # Esperamos 1 segundo para crear el intervalo de medición
    sleep 1
    local ts
    ts=$(date "+%Y-%m-%d %H:%M:%S")

    for pair in "${pairs[@]}"; do
      local pid="${pair%%:*}"
      local name="${pair#*:}"

      if [[ -f "/proc/$pid/stat" ]]; then
        local content right stats
        content=$(< "/proc/$pid/stat")
        right="${content##*)}"
        read -r -a stats <<< "$right"

        local utime="${stats[11]}"
        local stime="${stats[12]}"
        local total_ticks=$(( utime + stime ))
        local current_time
        current_time=$(date +%s.%N)

        # Recuperar valores previos (o usar actuales si falló inicialización)
        local p_ticks=${prev_ticks[$pid]:-$total_ticks}
        local p_time=${prev_time[$pid]:-$current_time}

        local delta_ticks=$(( total_ticks - p_ticks ))

        # Cálculo de CPU usando awk para aritmética flotante
        # Fórmula: (delta_ticks / clk_tck) / delta_seconds * 100
        # Esto reporta uso "instantáneo" como top (Irix mode: 1 core = 100%)
        local cpu_real
        cpu_real=$(awk -v dt="$delta_ticks" -v ct="$current_time" -v pt="$p_time" -v clk="$clk_tck" 'BEGIN {
            period = ct - pt;
            if (period <= 0) period = 1;
            usage = (dt / clk) / period * 100;
            printf "%.1f", usage
        }')

        # Actualizar estado
        prev_ticks[$pid]=$total_ticks
        prev_time[$pid]=$current_time

        # Obtener MEM y RSS via ps por simplicidad
        # Threads se obtiene directo de stat (idx 17 -> campo 20)
        local threads="${stats[17]}"

        local mem_data
        mem_data=$(ps -p "$pid" -o %mem=,rss= 2>/dev/null || echo "0.0 0")
        local mem rss
        read -r mem rss <<< "$mem_data"

        if [[ "$formato" == "resumido" ]]; then
          echo "[$ts] $name (PID $pid) CPU: ${cpu_real}% MEM: ${mem}%" | tee -a "$LOG_DIR"
        else
          echo "[$ts] $name (PID $pid) CPU: ${cpu_real}% MEM: ${mem}% RSS: ${rss}KB THREADS: $threads" | tee -a "$LOG_DIR"
        fi
      else
        echo "[$ts] $name (PID $pid) finalizó." | tee -a "$LOG_DIR"
      fi
    done
  done

  echo "$(date "+%Y-%m-%d %H:%M:%S") ----FIN----------------------------------------------------" | tee -a "$LOG_DIR"
  read -rp "ENTER para volver al menú..."
  menu_inicial
}

menu_inicial

