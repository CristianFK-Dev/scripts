# Script Interactivo para Gestionar Servicios Systemd

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

> ⚠️ **Este script realiza acciones que modifican el estado de los servicios del sistema (detener, reiniciar).**  
> Usalo con precaución, especialmente en entornos de producción.  
> ✅ Siempre revisá el código antes de ejecutarlo.

---

## ✨ Descripción

Este script (`006-service-systemd.sh`) ofrece una interfaz interactiva y amigable para gestionar los servicios de **systemd**. En lugar de escribir comandos largos, podés ver una **lista en múltiples columnas** de todos los servicios (activos e inactivos) y elegir una acción (`ver estado`, `iniciar`, `detener`, `reiniciar`) desde un menú dinámico y con colores.

Las opciones del menú de acciones están coloreadas para mejorar la legibilidad:
- **Ver Estado**: Verde (acción segura).
- **Iniciar**: Verde (acción segura).
- **Detener**: Rojo (acción potencialmente disruptiva).
- **Reiniciar**: Amarillo (acción de reinicio).
- La opción para **salir** del script está resaltada en naranja.

---

## 🛠️ Requisitos

- Distribución **Linux** con `systemd`.
- Permisos de **root** (`sudo`).
- Herramientas básicas como `systemctl`, `awk`, `bash`.

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/006-service-systemd.sh

chmod +x 006-service-systemd.sh

sudo ./006-service-systemd.sh
```

---

## 💡 Ejemplo de uso

1.  Al ejecutar el script, verás una lista de todos los servicios, numerados, organizados en columnas y con su estado indicado por un color.

    ```text
    Servicios del sistema (systemd):

       1) cron.service                         (activo)
       2) dbus.service                         (activo)
       3) networking.service                   (inactivo)
       ...

    👉 Elige un servicio por su número o escribe [s] para salir: 3
    ```

2.  Tras elegir un servicio, se mostrará un **menú de acciones dinámico**. Si el servicio estaba inactivo, ofrecerá la opción de iniciarlo.

    ```text
    🔧 Acciones para el servicio: networking.service

       1) Ver Estado (status)
       2) Iniciar (start)
       3) Volver al menú principal
       Tu elección:
    ```

3.  Al seleccionar una acción, el script la ejecutará y mostrará una confirmación.

    ```text
    🚀 Iniciando el servicio 'networking.service'...

    ✅ Servicio iniciado.

    Presioná ENTER para volver al menú principal...
    ```

---

## 🧠 ¿Por qué usar este script?

- **Agilidad**: Agiliza la gestión de servicios sin necesidad de recordar los comandos exactos de `systemctl`.
- **Claridad**: La interfaz interactiva y con colores reduce la posibilidad de cometer errores.
- **Eficiencia**: Ideal para administradores de sistemas que necesitan realizar comprobaciones o reinicios rápidos.
- **Completo**: Centraliza el ciclo de vida completo de un servicio (status, start, stop, restart) en un solo lugar.

---

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/006-service-systemd.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/006-service-systemd.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/006-service-systemd.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/006-service-systemd.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>