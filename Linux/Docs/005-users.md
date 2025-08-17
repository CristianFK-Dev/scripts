# Gestor Interactivo de Cuentas de Usuario

<p align="center">
    <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">
        <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    </a>
    <a href="https://www.debian.org/">
        <img src="https://img.shields.io/badge/OS-Linux%20%7C%20Debian-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
    </a>
</p>

---

## ⚠️ Advertencia de Seguridad Crítica

> Este script es una herramienta de administración poderosa que **realiza modificaciones directas y potencialmente destructivas en el sistema**. Permite crear, borrar, bloquear/desbloquear cuentas y contraseñas, y cambiar políticas de seguridad.
> - **Usalo con extrema precaución**, especialmente en entornos de producción.
> - **Un error puede dejar el sistema inaccesible** o comprometer su seguridad.
> - Siempre revisá el código antes de ejecutarlo y asegurate de entender cada acción.

---

## ✨ Descripción

Este script (`005-users.sh`) ha evolucionado de un simple reporte a un **completo dashboard interactivo para la gestión de usuarios en Linux**. Proporciona una interfaz centralizada para auditar y administrar cuentas de sistema, normales o todas juntas.

**Funcionalidades Principales:**
- **Filtrado de Usuarios**: Muestra usuarios del sistema, normales o todos.
- **Dashboard Detallado**: Presenta una tabla con información de seguridad clave:
  - **Shell asignado**: Si el usuario puede o no iniciar sesión.
  - **Estado de la contraseña**: `ACTIVA`, `BLOQUEADA`, `SIN PASS`.
  - **Estado de la cuenta**: Si la cuenta está bloqueada por expiración.
  - **Vencimiento de contraseña**: Cuándo caduca la contraseña.
  - **Último cambio**: Cuándo se modificó la contraseña por última vez.
  - **Políticas MIN/MAX**: Días de rotación de contraseñas.
  - **Último login**: Fecha del último inicio de sesión.
- **Menú de Acciones Interactivo**: Permite realizar las siguientes operaciones sobre cualquier usuario:
  - Ver estadísticas detalladas (`chage`, `id`, `lastlog`).
  - Bloquear y desbloquear contraseñas (`passwd -l/u`).
  - Bloquear y desbloquear cuentas completas (mediante expiración).
  - Establecer la fecha de vencimiento de la contraseña.
  - Cambiar la contraseña de un usuario.
  - Crear nuevos usuarios con configuración personalizada.
  - Borrar usuarios (con opción de eliminar su directorio home).

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

El script necesita permisos de superusuario para poder consultar la información de las contraseñas con `chage` y `passwd`.

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/005-users.sh

chmod +x 005-users.sh

sudo ./005-users.sh
```

## 💡 Ejemplo de uso

Al ejecutar el script, primero se te pedirá que elijas qué tipo de usuarios auditar:

```
USUARIO | SHELL               | ESTADO PASS      | BLOQUEO          | EXPIRACIÓN | ÚLTIMO CAMBIO | DÍAS MIN/MAX | ÚLTIMO LOGIN SSH
--------|---------------------|------------------|------------------|------------|---------------|-----------------------------
root    | 🟢 SHELL: /bin/bash | 🟢 ACTIVA       | ✅ DESBLOQUEADA | Nunca      | May 28, 2024  | 0/99999       | Thu Nov 7 14:22:11 -0300 2024
cristian| 🟢 SHELL: /bin/bash | 🟢 ACTIVA       | ✅ DESBLOQUEADA | 90 days    | Sep 01, 2024  | 1/90          | Nunca
daemon  | 🔴 NO SHELL         | N/A              | N/A             | N/A        | N/A           | N/A           | Nunca 
ftp     | 🔴 NO SHELL         | N/A              | N/A             | N/A        | N/A           | N/A           | Nunca
```

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
