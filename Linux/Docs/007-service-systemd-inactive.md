# Script para Iniciar Servicios Inactivos

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

> ⚠️ **Este script realiza acciones que modifican el estado de los servicios del sistema (iniciar).**  
> Usalo con precaución, especialmente en entornos de producción.  
> ✅ Siempre revisá el código antes de ejecutarlo.

---

## ✨ Descripción

Este script (`007-service-inactive-manager.sh`) es una herramienta enfocada en una sola tarea: gestionar servicios **inactivos** de **systemd**. Te permite ver una lista de todos los servicios que no están corriendo y te da un menú simple para **iniciarlos** o **ver su estado detallado**.

Es ideal para cuando un servicio se ha detenido y necesitas levantarlo rápidamente sin escribir comandos largos.

---

## 🛠️ Requisitos

- Distribución **Linux** con `systemd`.
- Permisos de **root** (`sudo`).
- Herramientas básicas como `systemctl`, `awk`, `bash`.

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/007-service-systemd-inactive.sh

chmod +x 007-service-inactive-manager.sh

sudo ./007-service-inactive-manager.sh
```

---

## 💡 Ejemplo de uso

1.  Al ejecutar el script, verás una lista de todos los servicios inactivos.

    ```text
    --- Servicios Inactivos ---

       1) apache2.service
       2) bluetooth.service
       3) cups.service
       ...

    👉 Elige un servicio por su número o escribe [s] para salir: 1
    ```

2.  Tras elegir un servicio, se mostrará el menú de acciones.

    ```text
    🔧 Acciones para el servicio inactivo: apache2.service

       1) Iniciar (start)
       2) Ver Estado (status)
       3) Volver a la lista
       
       Tu elección: 1
    ```

---

## 🧠 ¿Por qué usar este script?

- **Enfoque**: Diseñado para una sola tarea, lo que lo hace rápido y fácil de usar.
- **Eficiencia**: Levanta servicios caídos rápidamente desde una interfaz interactiva.
- **Claridad**: Evita errores al seleccionar servicios de una lista en lugar de escribirlos a mano.

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/007-service-inactive-manager.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/007-service-inactive-manager.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/007-service-inactive-manager.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/007-service-inactive-manager.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>