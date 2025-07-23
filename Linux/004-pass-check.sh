#!/usr/bin/env bash

set -euo pipefail

read -rsp "Ingrese la contraseña a analizar: " PASSWORD
echo

# Contadores
upper=$(grep -o '[A-Z]' <<< "$PASSWORD" | wc -l)
lower=$(grep -o '[a-z]' <<< "$PASSWORD" | wc -l)
digit=$(grep -o '[0-9]' <<< "$PASSWORD" | wc -l)
symbol=$(grep -o '[^a-zA-Z0-9]' <<< "$PASSWORD" | wc -l)
total_length=${#PASSWORD}

# Set de caracteres por tipo
charsets=0
[[ $upper -gt 0 ]] && charsets=$((charsets + 26))
[[ $lower -gt 0 ]] && charsets=$((charsets + 26))
[[ $digit -gt 0 ]] && charsets=$((charsets + 10))
[[ $symbol -gt 0 ]] && charsets=$((charsets + 32)) # Suponemos 32 símbolos válidos

# Combinaciones posibles (entropía bruta)
combinations=$(echo "$charsets^$total_length" | bc)
entropy_bits=$(echo "l($combinations)/l(2)" | bc -l)

# Estimación de tiempo para romperla (en segundos)
ATTEMPTS_PER_SEC=1000000000  # 1 mil millones intentos/seg (ataque GPU distribuido)
seconds=$(echo "$combinations / $ATTEMPTS_PER_SEC" | bc)
years=$(echo "$seconds / 60 / 60 / 24 / 365" | bc)

# Clasificación simple
if (( $(echo "$entropy_bits < 40" | bc -l) )); then
    strength="❌ Débil"
elif (( $(echo "$entropy_bits < 60" | bc -l) )); then
    strength="⚠ Media"
else
    strength="✅ Fuerte"
fi

# Salida
echo "--------------------------------------------"
echo "Longitud total         : $total_length"
echo "Mayúsculas             : $upper"
echo "Minúsculas             : $lower"
echo "Números                : $digit"
echo "Símbolos               : $symbol"
echo "Charset combinado      : $charsets caracteres posibles"
echo "Combinaciones posibles : $combinations"
echo "Entropía estimada      : ${entropy_bits%.*} bits"
echo "Tiempo para romperla   : ~ $years años (a $ATTEMPTS_PER_SEC intentos/seg)"
echo "Clasificación          : $strength"
echo "--------------------------------------------"
