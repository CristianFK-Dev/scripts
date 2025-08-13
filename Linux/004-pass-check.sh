#!/usr/bin/env bash

set -euo pipefail

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

cs
echo -e "\n🧾 analizar-entropia.sh\n"
echo -e "Este script analiza la fortaleza de una contraseña calculando su entropía."
echo -e "Deberás ingresar una contraseña, y el script te mostrará un desglose de"
echo -e "sus caracteres y la cantidad total de combinaciones posibles.\n"
read -rp "Presioná ENTER para continuar..."
cs

if ! command -v bc &> /dev/null; then
    echo -e "\n❌ Error: La herramienta 'bc' no está instalada."
    echo -e "   Por favor, instalala para poder realizar los cálculos."
    echo -e "   En sistemas Debian/Ubuntu: sudo apt install bc\n"
    exit 1
fi

read -rsp "🔑 Ingresá la contraseña a verificar: " password
echo 

if [[ -z "$password" ]]; then
    echo -e "\n❌ No ingresaste ninguna contraseña. Saliendo.\n"
    exit 1
fi

total_chars=${#password}
count_lower=$(echo "$password" | grep -o '[a-z]' | wc -l)
count_upper=$(echo "$password" | grep -o '[A-Z]' | wc -l)
count_digits=$(echo "$password" | grep -o '[0-9]' | wc -l)
count_symbols=$(echo "$password" | grep -o '[^a-zA-Z0-9]' | wc -l)


pool_size=0
if [[ $count_lower -gt 0 ]]; then
    pool_size=$((pool_size + 26)) # a-z
fi
if [[ $count_upper -gt 0 ]]; then
    pool_size=$((pool_size + 26)) # A-Z
fi
if [[ $count_digits -gt 0 ]]; then
    pool_size=$((pool_size + 10)) # 0-9
fi
if [[ $count_symbols -gt 0 ]]; then
    pool_size=$((pool_size + 32))
fi


entropy=$(echo "$total_chars * (l($pool_size) / l(2))" | bc -l)
entropy_rounded=$(printf "%.0f\n" "$entropy")

total_combinations=$(echo "$pool_size^$total_chars" | bc)

# --- Muestra de Resultados ---
cs
echo -e "\n📊 Análisis de tu contraseña:\n"
echo -e "   Total de caracteres:\t$total_chars"
echo -e "   Letras minúsculas:\t$count_lower"
echo -e "   Letras mayúsculas:\t$count_upper"
echo -e "   Números:\t\t$count_digits"
echo -e "   Símbolos:\t\t$count_symbols"
echo -e "   -----------------------------------------"

echo -e "\n🧠 Fortaleza calculada:\n"
echo -e "   🔹 Espacio de caracteres (R):\t$pool_size"
echo -e "      (Suma de los conjuntos de caracteres únicos utilizados)\n"
echo -e "   🔹 Entropía (redondeada):\t${entropy_rounded} bits"
echo -e "      (Una medida de la impredictibilidad. >80 bits es excelente)\n"
echo -e "   🔹 Combinaciones totales (R^L):\n      $total_combinations\n"

echo -e "✅ Script finalizado.\n"