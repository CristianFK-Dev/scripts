#!/usr/bin/env bash

set -euo pipefail

LOGFILE="/var/log/001-apt-upgrade.log"

cs() {
    clear
}

if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

cs
echo -e " .______________________________________________________________________________________________________."
echo -e " | 🧾 001-apt-upgrade.sh                                                                                |"                                                                            
echo -e " | Este script actualiza la lista de paquetes APT o upgrade del so completo.                            |"
echo -e " | Podés elegir uno o varios paquetes por número, o instalar todos.                                     |" 
echo -e " | Los datos quedan registrados en $LOGFILE                                         |"
echo -e " |______________________________________________________________________________________________________|\n"
read -rp " Presioná ENTER para continuar..." 

while true; do
    cs
    echo -e "\n🔄 Actualizando lista de paquetes...\n"

    mapfile -t packages < <(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk -F'/' '{print $1}' | nl -w2 -s'. ')
    mapfile -t rawinfo < <(apt list --upgradable 2>/dev/null | grep -v "Listing...")

    cs
    if [ ${#packages[@]} -eq 0 ]; then
        echo -e "\n✅ Todo está actualizado. No hay paquetes pendientes.\n"
    else
        echo -e "📦 Paquetes que se pueden actualizar:"
        printf "%s\n" "${packages[@]}"
    fi

    echo -e "\n📦 Ingresá los números de los paquetes a instalar (separados por espacio)"
    echo -e " 'a': Todos"
    echo -e " 'u': Upgrade completo"
    echo -e " 'l': Ver log"
    echo -e " 's': Salir"
    read -rp " Tu elección 👉: " choice 

    if [[ -z "$choice" ]]; then
        echo -e "\n❌ Selección inválida. Debes ingresar una opción."
        sleep 2
        continue
    fi

    if [[ "$choice" == "s" || "$choice" == "salir" ]]; then
        cs && echo -e "\n👋 Saliendo sin hacer cambios.\n"
        exit 0
    fi

    if [[ "$choice" == "l" ]]; then
        cs
        echo -e "\n📄 Mostrando últimas 100 líneas del log:\n"
        tail -n 100 "$LOGFILE"
        echo -e "\nPresioná ENTER para volver al menú..." 
        read -r
        continue
    fi

    if [[ "$choice" == "u" ]]; then
        cs
        echo -e "\n⚡ Ejecutando upgrade completo del sistema...\n"
        apt upgrade -y >> "$LOGFILE" 2>&1
        echo "======$(date '+%Y-%m-%d %H:%M:%S') Upgrade completo ======" >> "$LOGFILE"
        echo -e "✅UPGRADE: Upgrade completo finalizado." >> "$LOGFILE"
        echo -e "Presioná ENTER para volver al menú..."
        read -r
        continue
    fi

    if [ ${#packages[@]} -eq 0 ]; then
        continue
    fi

    to_install=()

    if [[ "$choice" == "a" ]]; then
        to_install=( $(printf "%s\n" "${rawinfo[@]}" | awk -F'/' '{print $1}') )
    else
        for num in $choice; do
            if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#packages[@]} )); then
                echo -e "\n❌ Número inválido: $num"
                sleep 2
                continue 2
            fi
            pkg_line="${packages[$((num-1))]}"
            pkg_name=$(echo "$pkg_line" | awk '{print $2}')
            to_install+=( "$pkg_name" )
        done
    fi

    cs
    echo -e "\n🚀 Instalando paquetes seleccionados...\n"
    apt install -y "${to_install[@]}" >> "$LOGFILE" 2>&1

    {
        echo "======$(date '+%Y-%m-%d %H:%M:%S') Instalación realizada ======"
        for pkg in "${to_install[@]}"; do
            ver=$(dpkg -l "$pkg" 2>/dev/null | awk '/^ii/ {print $2, $3}')
            echo "✅INSTALADO: $ver"
        done
        echo ""
    } >> "$LOGFILE"

    sleep 2
    cs

    echo -e "\n✅ Instalación finalizada. Versiones instaladas:\n"
    for pkg in "${to_install[@]}"; do
        ver=$(dpkg -l "$pkg" 2>/dev/null | awk '/^ii/ {print $2, $3}')
        echo "🔹 $ver"
        echo ""
    done
    echo -e "Presioná ENTER para volver al menú..."
    read -
done
