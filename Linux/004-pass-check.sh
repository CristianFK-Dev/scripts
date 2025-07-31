#!/usr/bin/env bash

set -euo pipefail

if [ -t 1 ]; then
    clear
fi

# Función para calcular entropía
calc_entropy() {
    local password=$1
    local length=${#password}
    local char_classes=0

    # Verificar clases de caracteres presentes
    [[ $password =~ [a-z] ]] && ((char_classes+=26))   # Minúsculas
    [[ $password =~ [A-Z] ]] && ((char_classes+=26))   # Mayúsculas
    [[ $password =~ [0-9] ]] && ((char_classes+=10))   # Números
    [[ $password =~ [^a-zA-Z0-9] ]] && ((char_classes+=32))  # Símbolos (ASCII común)

    # Cálculo de entropía (fórmula: log2(R^L)) donde R=clases, L=longitud
    local entropy=$(echo "scale=2; l($char_classes^$length)/l(2)" | bc -l)
    
    # Evaluación cualitativa
    if (( $(echo "$entropy < 28" | bc -l) ); then
        strength="Muy Débil 🔴"
    elif (( $(echo "$entropy < 36" | bc -l) ); then
        strength="Débil 🟠"
    elif (( $(echo "$entropy < 60" | bc -l) ); then
        strength="Moderada 🟡"
    elif (( $(echo "$entropy < 128" | bc -l) ); then
        strength="Fuerte 🟢"
    else
        strength="Muy Fuerte 🔵"
    fi

    echo "--------------------------------"
    echo "🔐 Análisis de Contraseña"
    echo "--------------------------------"
    echo "Longitud: $length caracteres"
    echo "Clases de caracteres:"
    echo "  - Minúsculas: $( [[ $password =~ [a-z] ]] && echo "Sí ✅" || echo "No ❌" )"
    echo "  - Mayúsculas: $( [[ $password =~ [A-Z] ]] && echo "Sí ✅" || echo "No ❌" )"
    echo "  - Números: $( [[ $password =~ [0-9] ]] && echo "Sí ✅" || echo "No ❌" )"
    echo "  - Símbolos: $( [[ $password =~ [^a-zA-Z0-9] ]] && echo "Sí ✅" || echo "No ❌" )"
    echo "--------------------------------"
    echo "Entropía: $entropy bits"
    echo "Fortaleza estimada: $strength"
    echo "--------------------------------"
}

# Solicitar contraseña (modo seguro sin eco)
read -sp "Ingresa tu contraseña: " password
echo -e "\n"
calc_entropy "$password"