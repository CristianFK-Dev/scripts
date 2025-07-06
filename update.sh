#!/bin/bash
set -euo pipefail

# Verificamos si es root
if [[ $EUID -ne 0 ]]; then
    echo "🔒 Este script debe ejecutarse como root (usá sudo)"
    exit 1
fi

echo "🔄 Actualizando lista de paquetes..."
apt update -y > /dev/null

# Obtener lista de paquetes actualizables
mapfile -t packages < <(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk -F'/' '{print $1}' | nl -w2 -s'. ')
mapfile -t rawinfo < <(apt list --upgradable 2>/dev/null | grep -v "Listing...")

if [ ${#packages[@]} -eq 0 ]; then
    echo "✅ Todo está actualizado. No hay paquetes pendientes."
    exit 0
fi

echo -e "\n📦 Paquetes que se pueden actualizar:"
printf "%s\n" "${packages[@]}"

echo -e "\n👉 Ingresá los números de los paquetes a instalar (separados por espacio), o 'a' para todos:"
read -rp "Tu elección: " choice

to_install=()

if [[ $choice == "a" ]]; then
    # Instalar todos
    to_install=( $(printf "%s\n" "${rawinfo[@]}" | awk -F'/' '{print $1}') )
else
    for num in $choice; do
        pkg_line="${packages[$((num-1))]}"
        pkg_name=$(echo "$pkg_line" | awk '{print $2}')
        to_install+=( "$pkg_name" )
    done
fi

echo -e "\n🚀 Instalando paquetes seleccionados..."
apt install -y "${to_install[@]}"

echo -e "\n✅ Instalación finalizada. Versiones instaladas:"
for pkg in "${to_install[@]}"; do
    ver=$(dpkg -l "$pkg" 2>/dev/null | awk '/^ii/ {print $2, $3}')
    echo "🔹 $ver"
done
