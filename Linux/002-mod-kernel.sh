#!/bin/bash

set -euo pipefail

# Mostrar documentación y esperar
echo -e "\n🧾002-mod-kernel.sh\n"
echo -e "Este script permite listar y eliminar módulos del kernel activos."
echo -e "También permite ver si hay módulos bloqueados por archivos de blacklist."
echo -e "Por seguridad, se pedirá que escribas el nombre exacto del módulo antes de eliminarlo.\n"
read -rp "Presioná ENTER para continuar..."

# Verificamos si es root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)"
    exit 1
fi

# Mostrar primero módulos bloqueados
echo -e "\n🔍 Verificando módulos bloqueados en /etc/modprobe.d/blacklist*..."

blacklist_files=$(find /etc/modprobe.d/ -type f -name "*blacklist*.conf")

mostrar_blacklist() {
    if [[ -z "$blacklist_files" ]]; then
        echo -e "✅ No se encontraron archivos de blacklist en /etc/modprobe.d/"
    else
        echo -e "📁 Archivos de blacklist encontrados:"
        echo "$blacklist_files" | sed 's/^/   📄 /'
        echo -e "\n📌 Módulos bloqueados (blacklisted):\n"
        grep -h '^blacklist' $blacklist_files | awk '{print "🚫 " $2}' | sort | uniq
    fi
}

mostrar_blacklist

# Listar módulos activos
echo -e "\n📦 Listando módulos del kernel activos...\n"
mapfile -t modules < <(lsmod | awk 'NR>1 {print $1, $3}' | sort | nl -w2 -s'. ')

if [ ${#modules[@]} -eq 0 ]; then
    echo -e "\n✅ No hay módulos activos (muy raro)\n"
    exit 0
fi

for mod in "${modules[@]}"; do
    echo "$mod"
done

# Preguntar qué módulo desactivar
echo
read -rp "👉 Ingresá el número del módulo a desactivar o escribí 'exit' para salir: " index

# Verificar si quiere salir
if [[ "$index" == "exit" || "$index" == "salir" ]]; then
    echo -e "\n👋 Saliendo sin hacer cambios.\n"
    exit 0
fi

# Validar número ingresado
if ! [[ "$index" =~ ^[0-9]+$ ]] || (( index < 1 || index > ${#modules[@]} )); then
    echo -e "\n❌ Opción inválida\n"
    exit 1
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

# Intentamos eliminar el módulo
echo -e "\n🚧 Desactivando módulo..."
if modprobe -r "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' desactivado correctamente con modprobe -r"
elif rmmod "$mod_name" 2>/dev/null; then
    echo -e "\n✅ Módulo '$mod_name' removido con rmmod"
else
    echo -e "\n❌ Error al remover el módulo. Puede estar en uso o ser crítico del sistema."
    exit 1
fi

# Preguntar si desea volver a cargar un módulo
read -rp "¿Querés volver a cargar (habilitar) un módulo? (s/n): " reload
if [[ "$reload" == "s" ]]; then
    read -rp "🔁 Ingresá el nombre exacto del módulo que querés volver a cargar: " to_load
    if modprobe "$to_load" 2>/dev/null; then
        echo -e "\n✅ Módulo '$to_load' cargado correctamente con modprobe"
    else
        echo -e "\n❌ No se pudo cargar el módulo. Verificá que exista y no esté bloqueado."
    fi
fi

# Mostrar nuevamente la blacklist al final
echo -e "\n📋 Estado actual de módulos bloqueados tras la modificación:\n"
mostrar_blacklist
