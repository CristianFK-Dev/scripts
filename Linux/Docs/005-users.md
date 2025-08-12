# Script de Auditoría de Cuentas de Usuario

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
> Siempre revisá el contenido de cualquier script antes de ejecutarlo, especialmente si lo descargás de internet o desde un repositorio.
> Este script **no realiza modificaciones en el sistema**, solo imprime un reporte con fines de auditoría y requiere permisos de `root` para leer la información de las cuentas.

---

## ✨ Descripción

Este script (`005-users.sh`) muestra un reporte detallado del estado de **todas las cuentas de usuario del sistema**. El reporte prioriza a los usuarios con un shell de inicio de sesión activo, listándolos primero para facilitar la auditoría.

Incluye información clave sobre la seguridad de cada cuenta:

- **Shell asignado**: Si el usuario puede o no iniciar sesión.
- **Estado de la contraseña**: `activa`, `bloqueada`, `sin contraseña`, etc.
- **Estado de bloqueo**: Si la cuenta está bloqueada por fallos de autenticación.
- **Fecha de expiración**: Cuándo caduca la contraseña.
- **Último cambio**: Cuándo se modificó la contraseña por última vez.
- **Días MIN/MAX**: Políticas de rotación de contraseñas.
- **Último login ssh**: Fecha y hora del último inicio de sesión interactivo con SSH.

Es una herramienta ideal para auditorías de seguridad y para generar evidencia para controles como **CIS Benchmark 6.2.x** o **PCI DSS 8.x**.

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

La salida será una tabla bien alineada como la siguiente, mostrando todos los campos relevantes:

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
