#!/usr/bin/env bash

set -euo pipefail

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

# Mostrar documentación y esperar
cs
echo -e "\n🧾001-apt-upgrade.sh\n"
echo -e "Este script actualiza la lista de paquetes APT y permite instalar selectivamente los actualizables."
echo -e "Podés elegir uno o varios por número, o instalar todos.\n"
read -rp "Presioná ENTER para continuar..."
cs

# Verificamos si es root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

echo -e "\n🔄 Actualizando lista de paquetes...\n"
apt update -y > /dev/null

# Obtener lista de paquetes actualizables
mapfile -t packages < <(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk -F'/' '{print $1}' | nl -w2 -s'. ')
mapfile -t rawinfo < <(apt list --upgradable 2>/dev/null | grep -v "Listing...")

if [ ${#packages[@]} -eq 0 ]; then
    echo -e "\n✅ Todo está actualizado. No hay paquetes pendientes.\n"
    exit 0
fi

echo -e "\n📦 Paquetes que se pueden actualizar:"
printf "%s\n" "${packages[@]}"

echo -e "\n👉 Ingresá los números de los paquetes a instalar (separados por espacio), o 'a' para todos , exit para salir:"
read -rp " Tu elección: " choice

# Verificar si quiere salir
if [[ "$choice" == "exit" || "$choice" == "salir" ]]; then
    cs && echo -e "\n👋 Saliendo sin hacer cambios.\n"
    exit 0
fi

to_install=()

if [[ "$choice" == "a" ]]; then
    # Instalar todos
    to_install=( $(printf "%s\n" "${rawinfo[@]}" | awk -F'/' '{print $1}') )
else
    for num in $choice; do
        if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#packages[@]} )); then
            echo -e "\n❌ Número inválido: $num"
            exit 1
        fi
        pkg_line="${packages[$((num-1))]}"
        pkg_name=$(echo "$pkg_line" | awk '{print $2}')
        to_install+=( "$pkg_name" )
    done
fi

echo -e "\n🚀 Instalando paquetes seleccionados...\n"
apt install -y "${to_install[@]}"
echo -e "\n Los logs se borraran en 5 segundos...\n"
sleep 5
cs

echo -e "\n✅ Instalación finalizada. Versiones instaladas:\n"
for pkg in "${to_install[@]}"; do
    ver=$(dpkg -l "$pkg" 2>/dev/null | awk '/^ii/ {print $2, $3}')
    echo "🔹 $ver"
    echo ""
done
