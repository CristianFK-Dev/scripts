# Script verificador de puertos y host

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

> ⚠️ **Este script solicita instalar nmap para su funcionamiento.**    
> 📌 Siempre revisá el código antes de ejecutarlo, o pedile a una IA que lo revise por vos.

---

## 🧾 Descripción

Este script analiza **puertos y servicios** en un host objetivo  
permitiendo verificar estados, servicios y obtener información adicional del sistema.

Este script:

- ✅ Verifica la disponibilidad del host objetivo
- 🔍 Escanea puertos específicos o comunes
- 📊 Muestra estado de puertos (abierto/cerrado)
- 🔎 Identifica servicios en puertos abiertos

Ideal para diagnósticos de red rápido, auditorías de seguridad o verificación de servicios.

---

## 🛠️ Requisitos

- Bash
- nmap
- netcat (nc)
- Permisos de root para algunas funciones

---

## 🚀 Uso

### 📥 Descargar y ejecutar

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/004-ports-check.sh

chmod +x 004-ports-check.sh

sudo ./004-ports-check.sh
```

## 💡 Ejemplo de uso

```
🔍 004-ports-check.sh - Verificador de puertos y host

👉 Ingresá la IP del host: 192.168.1.100

✅ Host 192.168.1.100 encontrado

Información del host:
-------------------
Host is up (0.0023s latency)

Ingresá los puertos a verificar:
  - Separados por espacios (ej: 22 80 443)
  - 'a' para todos los puertos comunes
👉 Puertos: 22 80 443

🔍 Verificando puertos específicos...
Puerto 22: ABIERTO (SSH)
Puerto 80: ABIERTO (HTTP)
Puerto 443: CERRADO (N/A)

📊 Información adicional:
------------------------
🕒 Uptime: up 15 days, 3:42
```

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/004-ports-check.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/004-ports-check.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/004-ports-check.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/004-ports-check.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
