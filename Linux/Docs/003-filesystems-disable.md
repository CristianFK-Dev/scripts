# Script desactivar sistemas de archivos

<p align="center">
    <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">
        <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    </a>
    <a href="https://www.debian.org/">
        <img src="https://img.shields.io/badge/OS-Linux%20%7C%20Debian-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
    </a>
</p>

---

## ⚠️ Advertencia de Seguridad

> **Este script modifica el comportamiento del kernel en tiempo real.**  
> ⚠️ Solo se recomienda para usuarios avanzados o tareas de hardening específicas.  
> 🔒 Revisá el script antes de ejecutarlo. También podés copiarlo y analizarlo con una IA confiable.

---

## 🧾 Descripción

Este script te permite:

- Listar todos los **sistemas de archivos activos soportados por el kernel**
- Seleccionar **interactivamente** uno de ellos
- Desactivarlo mediante `modprobe -r` o `rmmod`
- Confirmar la acción escribiendo el nombre del módulo para mayor seguridad

Ideal para tareas de **endurecimiento del sistema (hardening)** desactivando FS no necesarios como `cramfs`, `udf`, `squashfs`, etc.

---

## 🛠️ Requisitos

- ✅ Linux
- 🛡️ Permisos de superusuario (`sudo`)
- Herramientas: `bash`, `grep`, `awk`, `modprobe`, `rmmod`, `sort`

---

## 🚀 Uso

### 📥 Descargar y ejecutar

```bash
curl -O https://raw.githubusercontent.com/Golidor24/scripts/main/Linux/003-filesystems-disable.sh

chmod +x 003-filesystems-disable.sh

sudo ./003-filesystems-disable.sh

```

---

## 💡 Ejemplo de uso

Al ejecutar el script:

```
🧾 003-filesystems-disable.sh

Este script permite listar y desactivar sistemas de archivos soportados por el kernel.
Podés usarlo para deshabilitar módulos como cramfs, udf, squashfs, etc.

Presioná ENTER para continuar...
```

Luego:

```
📂 Listando sistemas de archivos cargados...

 1. cramfs
 2. squashfs
 3. udf
 ...

👉 Ingresá el número del sistema de archivos a desactivar o 'exit' para salir:
```

Después de confirmar el nombre:

```bash
✅ Módulo 'squashfs' desactivado correctamente con modprobe -r
```

---

## 🧠 ¿Por qué usar este script?

- 🔐 Desactivar sistemas de archivos que **no usás mejora la seguridad** de tu sistema.
- 🧹 Elimina vectores de ataque potenciales.
- ✅ Ideal para reforzar entornos que siguen normas **CIS**, **PCI-DSS** o hardening de servidores.

---

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/Golidor24/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/Golidor24/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/Golidor24/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/Golidor24/scripts/blob/main/Linux/003-filesystems-disable.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
