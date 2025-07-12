# 🚀 001-update.sh - Gestor de Actualizaciones APT Interactivo

<p align="center">
    <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    <img src="https://img.shields.io/badge/OS-Debian%20%7C%20Ubuntu%20%7C%20Derivados-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
</p>

---

## ⚠️ Recomendaciones de Seguridad

⚠️ **Advertencia Importante**  
Siempre revisá el contenido del script antes de ejecutarlo, especialmente si lo descargás de internet. Este script requiere permisos de superusuario y modifica paquetes del sistema.  
También podés pasárselo a una IA como ChatGPT para que lo analice por vos.

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

### ✅ Paso a paso:

1. **Descargar el script:**

   ```bash
   curl -O https://raw.githubusercontent.com/TU_USUARIO/scripts/main/001-update.sh
   chmod +x 001-update.sh
   ```

2. **Ejecutar el script:**

   ```bash
   sudo ./001-update.sh
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

## 📁 Estructura recomendada

```
scripts/
└── 001-update.sh
Docs/
└── 001-update.md
```

---

## 📤 Compartir este script

[![GitHub](https://img.shields.io/badge/Compartir-181717?logo=github&logoColor=white)](https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![Reddit](https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white)](https://www.reddit.com/submit?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![WhatsApp](https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white)](https://wa.me/?text=Revisá%20este%20script:%20https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
[![Telegram](https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white)](https://t.me/share/url?url=https://github.com/TU_USUARIO/scripts/blob/main/001-update.sh)
