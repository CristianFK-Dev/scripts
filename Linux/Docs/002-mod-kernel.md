# Script para desactivar y activar módulos del kernel

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

> ⚠️ **Este script realiza acciones sensibles sobre el kernel de Linux.**  
> Usalo únicamente si sabés lo que estás haciendo.  
> ✅ **Nunca elimines módulos críticos del sistema** (como `ext4`, `xfs`, `netfilter`, etc).  
> 📌 Siempre revisá el código antes de ejecutarlo, o pedile a una IA que lo revise por vos.

---

## 🧾 Descripción

Este script permite:

- 🚫 Verificar los módulos **bloqueados por blacklist** en `/etc/modprobe.d/`
- 📦 Listar todos los módulos del kernel activos (`lsmod`)
- 🔢 Mostrar la lista de forma numerada y ordenada
- 🧹 Desactivar (eliminar) un módulo del kernel activo
- 🔁 Volver a cargar un módulo manualmente si fue descargado

Es útil para tareas de:

- 🔬 Debugging de drivers
- 🧪 Pruebas en entornos virtuales o de laboratorio
- 🧹 Limpieza temporal de módulos

---

## 🛠️ Requisitos

- Distribución **Linux**
- Permisos de **root** (`sudo`)
- Herramientas necesarias: `lsmod`, `modprobe`, `rmmod`, `awk`, `find`, `grep`, `bash`

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/002-mod-kernel.sh

chmod +x 002-mod-kernel.sh

sudo ./002-mod-kernel.sh
```
Inicio del scritpt:
```text
🧾002-mod-kernel.sh

Este script permite listar y eliminar módulos del kernel activos.
También permite ver si hay módulos bloqueados por archivos de blacklist.

Presioná ENTER para continuar...
```
Verificaciòn de mòdulos bloqueados:

```text 
🔍 Verificando módulos bloqueados en /etc/modprobe.d/blacklist*...
📁 Archivos de blacklist encontrados:
   📄 /etc/modprobe.d/blacklist.conf

📌 Módulos bloqueados (blacklisted):
🚫 dccp
🚫 sctp
🚫 cramfs
```
Listado de mòdulos activos:
```text
📦 Listando módulos del kernel activos...

 1. i915 4320
 2. e1000e 223
 3. snd_hda_intel 164
 ...
```
Desactivar mòdulo:
```text
👉 Ingresá el número del módulo a desactivar o escribí 'exit' para salir:
```
Informaciòn de seguridad y check de desactivaciòn:
```text
⚠️ Estás por intentar desactivar o eliminar el módulo: snd_hda_intel
🔐 Por seguridad, escribí el nombre exacto del módulo para confirmar: snd_hda_intel

✅ Módulo 'snd_hda_intel' desactivado correctamente con modprobe -r
```
Opcional para volver a cargar mòdulo:
```text
¿Querés volver a cargar (habilitar) un módulo? (s/n): s
🔁 Ingresá el nombre exacto del módulo que querés volver a cargar: snd_hda_intel

✅ Módulo 'snd_hda_intel' cargado correctamente con modprobe
```
Lista de mòdulos bloqueados / desactivados:
```text
📋 Estado actual de módulos bloqueados tras la modificación:

🚫 dccp
🚫 sctp
🚫 cramfs
```

--- 

## 🧠 ¿Por qué usar este script?

- 🧪 Ideal para entornos de pruebas, debugging, desarrollo de drivers
- 🛑 Requiere precaución: no se recomienda para sistemas en producción sin conocimiento previo
- 🔍 Brinda una forma controlada de inspeccionar y manipular los módulos activos

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
