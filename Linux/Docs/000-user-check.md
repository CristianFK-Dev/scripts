# Script de Verificación de UID y EUID

<p align="center">
    <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    <img src="https://img.shields.io/badge/OS-Linux%20%7C%20macOS-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
</p>

## Recomendaciones

⚠️ **Advertencia de Seguridad Importante** ⚠️

Siempre revisá el contenido de cualquier script antes de ejecutarlo, especialmente si lo bajás de internet o desde un repositorio. Este script no realiza modificaciones en el sistema, pero es una buena práctica verificar el código o pedir a una IA como ChatGPT que lo audite.

---

## Descripción

Este script Bash (`000-check-user.sh`) muestra el UID (ID del usuario real que ejecuta el script) y el EUID (ID del usuario efectivo con el que se ejecuta el proceso).  
Sirve para comprobar si el proceso tiene permisos de root (`EUID = 0`) o no.

---

## Ejecución

Este script no requiere instalación. Podés descargarlo y ejecutarlo localmente.

### Descarga y ejecución local 💻

#### Linux / macOS:

```bash
curl -O https://raw.githubusercontent.com/TU_USUARIO/scripts/main/000-check-user.sh

chmod +x 000-check-user.sh

./000-check-user.sh

---

## 📤 Compartir este script

[![GitHub](https://img.shields.io/badge/Compartir-181717?logo=github&logoColor=white)](https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![Reddit](https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white)](https://www.reddit.com/submit?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![WhatsApp](https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white)](https://wa.me/?text=Revisá%20este%20script:%20https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![Telegram](https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white)](https://t.me/share/url?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
