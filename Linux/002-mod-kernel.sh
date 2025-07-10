#!/bin/bash

# ────────────────────────────────────────────────────────────────────────────────
# 📄 Documentación 002-mod-kernel
# Este script permite:
#   - Listar todos los módulos del kernel actualmente cargados (lsmod)
#   - Mostrar la lista con un número asignado
#   - Ingresar el número del módulo que se desea desactivar o eliminar
#   - Confirmar escribiendo el nombre exacto del módulo
#   - Desactivarlo con modprobe -r o rmmod según el caso
# Uso: sudo ./modulos-kernel.sh
# ────────────────────────────────────────────────────────────────────────────────

set -euo pipefail

echo
echo "🧾002-mod-kernel.sh"
echo
echo -e "Este script permite listar y eliminar módulos del kernel activos."
echo "Por seguridad, se pedirá que escribas el nombre exacto del módulo antes de eliminarlo."
echo
echo -e "Presioná ENTER para continuar..."
read -r

# Verificamos si es root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)"
    exit 1
fi

echo -e "\n📦 Listando módulos del kernel activos..."
echo

# Obtener módulos con sus nombres y versiones ordenados alfabéticamente
mapfile -t modules < <(lsmod | awk 'NR>1 {print $1, $3}' | sort | nl -w2 -s'. ')

if [ ${#modules[@]} -eq 0 ]; then
    echo -e "\n✅ No hay módulos activos (muy raro)\n"
    exit 0
fi

# Mostrar lista numerada
for mod in "${modules[@]}"; do
    echo "$mod"
done

echo
read -rp "👉 Ingresá el número del módulo a desactivar o escribí 'exit' para salir: " index

# Verificar si quiere salir
if [[ "$index" == "exit" || "$index" == "salir" ]]; then
    echo -e "\n👋 Saliendo sin hacer cambios."
    echo
    exit 0
fi

# Verificamos si es un número válido
if ! [[ "$index" =~ ^[0-9]+$ ]] || (( index < 1 || index > exit_option )); then
    echo -e "\n❌ Opción inválida\n"
    exit 1
fi

if (( index == exit_option )); then
    echo -e "\n👋 Saliendo sin hacer cambios."
    exit 0
fi

# Obtener nombre del módulo
mod_line="${modules[$((index-1))]}"
mod_name=$(echo "$mod_line" | awk '{print $2}')  # segundo campo: nombre del módulo

echo -e "\n⚠️ Estás por intentar desactivar o eliminar el módulo: \e[1m$mod_name\e[0m"
read -rp "🔐 Por seguridad, escribí el nombre exacto del módulo para confirmar: " confirm

if [[ "$confirm" != "$mod_name" ]]; then
    echo -e "\n❌ Nombre incorrecto. Cancelando."
    exit 1
fi

# Intentamos eliminarlo
echo -e "\n🚧 Desactivando módulo..."
if modprobe -r "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' desactivado correctamente con modprobe -r"
elif rmmod "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' removido con rmmod"
else
    echo -e "\n❌ Error al remover el módulo. Puede estar en uso o ser crítico del sistema."
    exit 1
fi
