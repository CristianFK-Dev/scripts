# Script gestor de Actualizaciones APT Interactivo

<p align="center">
    <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">
        <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    </a>
    <a href="https://www.debian.org/">
        <img src="https://img.shields.io/badge/OS-Linux%20%7C%20Debian-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
    </a>
</p>

---

## ⚠️ Recomendaciones de Seguridad

⚠️ **Advertencia Importante** 
> Siempre revisá el contenido de cualquier script antes de ejecutarlo, especialmente si lo bajás de internet o  desde un repositorio. Este script no realiza modificaciones en el sistema, pero es una buena práctica verificar el código o pedir a una IA como ChatGPT que lo audite.

---

## ✨ Descripción

Este script de Bash es una herramienta sencilla y robusta para **gestionar actualizaciones de paquetes APT** de forma interactiva.  
Permite ver los paquetes pendientes, elegir cuáles instalar, o instalar todos de una sola vez.

---

## 🛠️ Requisitos

- Sistema operativo basado en **Debian, Ubuntu o derivados**
- Acceso a permisos de **superusuario** (`sudo`)
- Tener el gestor de paquetes `apt` disponible

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

   ```bash
   curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/001-apt-upgrade.sh

   chmod +x 001-apt-upgrade.sh
   
   sudo ./001-apt-upgrade.sh
   ```

---

## 💡 Ejemplo de Interacción

Después de actualizar el índice de paquetes (`apt update`), verás una lista como esta:

```text
📦 Paquetes que se pueden actualizar:
 1. nano
 2. brave-browser
 3. vlc
 4. imagemagick

👉 Ingresá los números de los paquetes a instalar (separados por espacio), o 'a' para todos:
Tu elección:
```

- **Instalar uno solo:**
  ```bash
  Tu elección: 1
  ```

- **Instalar varios:**
  ```bash
  Tu elección: 1 3
  ```

- **Instalar todos:**
  ```bash
  Tu elección: a
  ```

Al finalizar, verás un resumen como este:

```bash
✅ Instalación finalizada. Versiones instaladas:

🔹 nano 6.4-1
🔹 vlc 3.0.18-4
```

---

## 🧠 ¿Por qué usar este script?

Este script es útil si querés:

- Tener **control selectivo** sobre las actualizaciones
- **Evitar romper dependencias** al hacer `apt upgrade` completo
- Automatizar y simplificar la gestión en servidores o equipos personales
- Obtener un **informe claro** al finalizar

---

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
