# Visor Interactivo de Logs Linux

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
> Este script requiere permisos de root para acceder a los logs del sistema.
> Se recomienda revisar el código antes de ejecutarlo con privilegios elevados.

---

## ✨ Descripción

Este script (`000-log-viewer.sh`) proporciona una interfaz interactiva para monitorear logs del sistema en tiempo real usando `multitail`.

**Características principales:**
- 📋 Lista todos los archivos .log disponibles en `/var/log`
- 🔍 Permite monitorear hasta 4 logs simultáneamente
- 🎨 Visualización en color para mejor legibilidad
- 🔄 Actualización en tiempo real
- 🔧 Instalación automática de dependencias

---

## 🛠️ Requisitos

- Bash
- multitail (se ofrece instalación automática)
- Permisos de root

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/000-log-viewer.sh

chmod +x 000-log-viewer.sh

sudo ./000-log-viewer.sh
```

### 💡 Ejemplo de uso:

1. Ejecutar el script con sudo
2. Seleccionar cantidad de logs a monitorear (1-4)
3. Elegir los logs por número
4. Ver el monitoreo en tiempo real
5. Usar Ctrl+C para volver al menú

---

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/000-log-viewer.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/000-log-viewer.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/000-log-viewer.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/000-log-viewer.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
