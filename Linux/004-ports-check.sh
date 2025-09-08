#!/usr/bin/env bash

set -euo pipefail

cs() {
    clear
}

check_dependencies() {
    local deps=(nc nmap)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            cs
            echo -e "❌ Falta $dep.\n"
            read -rp "¿Querés instalar $dep? [s/N]: " install
            case "${install,,}" in
                s|si|y|yes)
                    echo "🔄 Instalando $dep..."
                    if sudo apt update && sudo apt install -y "$dep"; then
                        echo "✅ $dep instalado correctamente"
                        sleep 1
                    else
                        echo "❌ Error instalando $dep"
                        exit 1
                    fi
                    ;;
                *)
                    echo "❌ $dep es necesario para ejecutar este script"
                    exit 1
                    ;;
            esac
        fi
    done
}

menu_inicial() {
    cs
    echo -e "\n🔍 004-ports-check.sh - Verificador de puertos y host\n"
    read -rp "👉 Ingresá la IP del host: " host_ip

    if ! ping -c 1 "$host_ip" &>/dev/null; then
        echo -e "\n❌ El host $host_ip no responde."
        sleep 2
        menu_inicial
    fi

    echo -e "\n✅ Host $host_ip encontrado\n"
    echo "Información del host:"
    echo "----------------------"
    nmap -sn "$host_ip" | grep -v "Starting"
    
    echo -e "\nIngresá los puertos a verificar:"
    echo "  - Separados por espacios (ej: 22 80 443)"
    echo "  - 'a' para puertos comunes"
    read -rp "👉 Puertos: " ports

    echo -e "\n-------------------------------------"
    if [[ "$ports" == "a" ]]; then
        echo -e "\n🔍 Escaneando puertos comunes..."
        echo -e "---------------------------------\n"
        nmap -sV "$host_ip" | grep -v "Starting"
    else
        echo -e "\n🔍 Verificando puertos específicos..."
        echo -e "-------------------------------------\n"
        for port in $ports; do
            if ! [[ "$port" =~ ^[0-9]+$ ]]; then
                echo "❌ Puerto inválido: $port"
                continue
            fi
            
            if nc -zv "$host_ip" "$port" 2>/dev/null; then
                estado="ABIERTO✅"
                servicio=$(nmap -p"$port" -sV "$host_ip" | grep "$port/tcp" | awk '{print $3}')
            else
                estado="CERRADO❌"
                servicio="Servicio N/A"
            fi
            
            echo "Puerto $port: $estado ($servicio)"
        done
    fi
    echo -e "\n-------------------------------------\n"
    echo -e "\n¿Querés escanear otro host? Si no lo haces, el script finalizará."
    read -rp "👉 [s/N]: " otra
    case "${otra,,}" in
        s|si|y|yes) menu_inicial ;;
        *) cs; echo -e "\n👋 ¡Hasta luego!\n"; exit 0 ;;
    esac
}

check_dependencies
menu_inicial
