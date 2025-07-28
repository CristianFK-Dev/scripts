#!/usr/bin/env bash

set -euo pipefail

if [ -t 1 ]; then
    clear
fi

read -rsp "Ingrese la contraseña a analizar: " PASSWORD
echo

# Verificar longitud mínima
total_length=${#PASSWORD}
if [[ $total_length -lt 8 ]]; then
    echo -e "\n❌ La contraseña debe tener al menos 8 caracteres."
    exit 1
fi

# Validar que bc esté instalado (solo para entropía)
if ! command -v bc >/dev/null; then
    echo -e "\n❌ Error: 'bc' no está instalado.\n"
    exit 1
fi

# Contadores de tipos de caracteres
upper=$(grep -o '[A-Z]' <<< "$PASSWORD" | wc -l)
lower=$(grep -o '[a-z]' <<< "$PASSWORD" | wc -l)
digit=$(grep -o '[0-9]' <<< "$PASSWORD" | wc -l)
symbol=$(grep -o '[^a-zA-Z0-9]' <<< "$PASSWORD" | wc -l)

# Verificar requisitos obligatorios de composición
if [[ $upper -eq 0 ]]; then
    echo -e "\n❌ La contraseña debe contener al menos una letra mayúscula."
    exit 1
fi

if [[ $lower -eq 0 ]]; then
    echo -e "\n❌ La contraseña debe contener al menos una letra minúscula."
    exit 1
fi

if [[ $digit -eq 0 ]]; then
    echo -e "\n❌ La contraseña debe contener al menos un número."
    exit 1
fi

if [[ $symbol -eq 0 ]]; then
    echo -e "\n❌ La contraseña debe contener al menos un carácter especial (símbolo)."
    exit 1
fi

# Determinar qué conjuntos de caracteres están presentes
charsets_count=0
charsets_description=""

[[ $upper -gt 0 ]] && { charsets_count=$((charsets_count + 26)); charsets_description+="mayúsculas (26) + "; }
[[ $lower -gt 0 ]] && { charsets_count=$((charsets_count + 26)); charsets_description+="minúsculas (26) + "; }
[[ $digit -gt 0 ]] && { charsets_count=$((charsets_count + 10)); charsets_description+="números (10) + "; }
[[ $symbol -gt 0 ]] && { charsets_count=$((charsets_count + 32)); charsets_description+="símbolos (32) + "; }

charsets_description=${charsets_description%+ }

# Combinaciones posibles y entropía
combinations=$(echo "$charsets_count^$total_length" | bc 2>/dev/null || echo "$charsets_count")
entropy_bits=$(echo "l($combinations)/l(2)" | bc -l 2>/dev/null | awk '{printf "%.0f", $1}')
[[ $entropy_bits -eq 0 ]] && entropy_bits=1

# Clasificación de fortaleza
if [[ $entropy_bits -lt 40 ]]; then
    strength="❌ Débil"
elif [[ $entropy_bits -lt 60 ]]; then
    strength="⚠ Media"
else
    strength="✅ Fuerte"
fi

# Mostrar resultados
echo "------------------------------------------------------------------"
echo "Longitud total         : $total_length"
echo "Mayúsculas             : $upper"
echo "Minúsculas             : $lower"
echo "Números                : $digit"
echo "Símbolos               : $symbol"
echo "Combinaciones posibles : $combinations"
echo "Entropía estimada      : $entropy_bits bits"
echo "Clasificación          : $strength"
echo "------------------------------------------------------------------"
