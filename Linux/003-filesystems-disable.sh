#!/usr/bin/env bash

set -euo pipefail

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

cs
echo -e "._______________________________________________________________________________________________________."
echo -e "| 🧾 003-filesystems-disable                                                                            |"
echo -e "|Este script permite listar y desactivar sistemas de archivos soportados por el kernel.                 |"
echo -e "|Podés usarlo para deshabilitar módulos como cramfs, udf, squashfs, etc.                                |"
echo -e "|_______________________________________________________________________________________________________|\n"

read -rp "Presioná ENTER para continuar..."
cs

if [ -t 1 ]; then
    clear
fi



echo -e "\n📂 Listando sistemas de archivos cargados..."

# Obtener lista única, ignorando nodev, ordenado alfabéticamente
mapfile -t fs_modules_raw < <(grep -v 'nodev' /proc/filesystems | awk '{print $1}' | sort)

if [ ${#fs_modules_raw[@]} -eq 0 ]; then
    echo -e "\n✅ No se encontraron sistemas de archivos cargados para desactivar\n"
    exit 0
fi

# Añadir numeración y mostrar lista
fs_modules=()
echo
for i in "${!fs_modules_raw[@]}"; do
    printf "%2d. %s\n" "$((i+1))" "${fs_modules_raw[$i]}"
    fs_modules+=("${fs_modules_raw[$i]}")
done

echo
read -rp "👉 Ingresá el número del sistema de archivos a desactivar o 's' para salir: " input

# Validar entrada
if [[ "$input" == "s" || "$input" == "salir" ]]; then
    cs && echo -e "\n👋 Saliendo sin hacer cambios.\n"
    exit 0
fi

if ! [[ "$input" =~ ^[0-9]+$ ]] || (( input < 1 || input > exit_option )); then
    echo -e "\n❌ Opción inválida\n"
    exit 1
fi

if (( input == exit_option )); then
    echo -e "\n👋 Saliendo sin hacer cambios.\n"
    exit 0
fi

mod_name="${fs_modules[$((input-1))]}"

echo -e "\n⚠️ Estás por intentar desactivar el sistema de archivos: \e[1m$mod_name\e[0m"
read -rp "🔐 Por seguridad, escribí el nombre exacto para confirmar: " confirm

if [[ "$confirm" != "$mod_name" ]]; then
    echo -e "\n❌ Nombre incorrecto. Cancelando."
    exit 1
fi

echo -e "\n🚧 Desactivando módulo asociado al sistema de archivos '$mod_name'..."

if modprobe -r "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' desactivado correctamente con modprobe -r"
elif rmmod "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' removido con rmmod"
else
    echo -e "\n❌ No se pudo remover el módulo. Puede no estar cargado, no tener módulo o estar en uso."
    exit 1
fi
