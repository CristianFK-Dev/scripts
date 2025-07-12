#!/bin/bash

set -euo pipefail

# Mostrar documentación y esperar
echo -e "\n🧾001-user-check.sh\n"
echo -e "Este script muestra el UID (usuario real) y el EUID (usuario efectivo)."
echo -e "Sirve para verificar si el proceso corre con permisos de root.\n"
read -rp "Presioná ENTER para continuar..."

# Mostrar los IDs
echo -e "\n👤 UID  (real user ID):      $UID"
echo    "🛡️  EUID (effective user ID): $EUID"

# Evaluar si se está ejecutando como root
if [[ $EUID -eq 0 ]]; then
    echo -e "\n✅ Este script se está ejecutando con privilegios de root (EUID = 0)"
else
    echo -e "\n❌ Este script NO se está ejecutando como root"
fi