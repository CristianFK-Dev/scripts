# Script para desactivar mòdulos del kernel

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
 
⚠️ **Este script realiza acciones sensibles sobre el kernel de Linux.**  
Usalo únicamente si sabés lo que estás haciendo.  
✅ **Nunca elimines módulos críticos del sistema** (como `ext4`, `xfs`, `netfilter`, etc).  
📌 Siempre revisá el código antes de ejecutarlo, o pedile a una IA que lo revise por vos.

---

## 🧾 Descripción

Este script permite:

- Listar todos los módulos del kernel activos actualmente (`lsmod`)
- Mostrar la lista de forma numerada y ordenada
- Elegir un módulo para desactivarlo/eliminarlo
- Confirmar la acción escribiendo el nombre exacto del módulo

Es útil para tareas de depuración o limpieza de módulos dinámicos en tiempo real.

---

## 🛠️ Requisitos

- Distribución **Linux**
- Permisos de **root** (`sudo`)
- Herramientas disponibles: `lsmod`, `modprobe`, `rmmod`, `awk`, `bash`

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/Golidor24/scripts/main/002-mod-kernel.sh
chmod +x 002-mod-kernel.sh
sudo ./002-mod-kernel.sh
```

---

## 💡 Ejemplo de ejecución

```bash
🧾002-mod-kernel.sh

Este script permite listar y eliminar módulos del kernel activos.
Por seguridad, se pedirá que escribas el nombre exacto del módulo antes de eliminarlo.

Presioná ENTER para continuar...
```

Luego mostrará algo como:

```text
📦 Listando módulos del kernel activos...

 1. i915 4320
 2. e1000e 223
 3. snd_hda_intel 164
 ...

👉 Ingresá el número del módulo a desactivar o escribí 'exit' para salir:
```

Después:

```bash
⚠️ Estás por intentar desactivar o eliminar el módulo: snd_hda_intel
🔐 Por seguridad, escribí el nombre exacto del módulo para confirmar: snd_hda_intel

✅ Módulo 'snd_hda_intel' desactivado correctamente con modprobe -r
```

---

## 🧠 ¿Por qué usar este script?

- 🧪 Ideal para **entornos de pruebas, debugging, desarrollo de drivers**
- 🛑 Requiere precaución: **no se recomienda para sistemas en producción sin conocimiento previo**
- 🔍 Brinda una forma controlada de inspeccionar y manipular los módulos activos

---

## 📁 Estructura sugerida

```
scripts/
└── 002-mod-kernel.sh
Docs/
└── 002-mod-kernel.md
```

---

## 📤 Compartir este script

[![GitHub](https://img.shields.io/badge/Compartir-181717?logo=github&logoColor=white)](https://github.com/Golidor24/scripts/blob/main/002-mod-kernel.sh)
[![Reddit](https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white)](https://www.reddit.com/submit?url=https://github.com/Golidor24/scripts/blob/main/002-mod-kernel.sh)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/Golidor24/scripts/blob/main/002-mod-kernel.sh)
[![Telegram](https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white)](https://t.me/share/url?url=https://github.com/Golidor24/scripts/blob/main/002-mod-kernel.sh)
[![WhatsApp](https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white)](https://wa.me/?text=Revisá%20este%20script:%20https://github.com/Golidor24/scripts/blob/main/002-mod-kernel.sh)