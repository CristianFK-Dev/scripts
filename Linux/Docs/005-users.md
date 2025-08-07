# Script de Verificación de Cuentas del Sistema (UID ≤ 1000)

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
> Este script **no realiza modificaciones en el sistema**, solo imprime un reporte con fines de auditoría.

---

## ✨ Descripción

Este script (`005-users.sh`) muestra un reporte detallado del estado de las **cuentas del sistema con UID menor o igual a 1000**, excluyendo al usuario `nobody`.

Incluye información sobre:

- Shell asignado
- Estado de la contraseña (`activa`, `bloqueada`, `sin contraseña`, `inexistente`)
- Estado de bloqueo por `pam` (`faillock` o `pam_tally2`)
- Fecha de caducidad de la contraseña (si aplica)

Sirve como evidencia para controles de auditoría como **CIS Benchmark 6.2.x** o **PCI DSS 8.x**.

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/005-users.sh

chmod +x 005-users.sh

./005-users.sh
```

## 💡 Ejemplo de uso


### ✅ CUENTAS DEL SISTEMA (UID <= 1000)

| Usuario | Estado Shell           | Contraseña   | Bloqueada        | Caducidad |
|---------|------------------------|--------------|------------------|-----------|
| root    | 🟢 SHELL: /bin/bash     | 🟢 ACTIVA     | ✅ DESBLOQUEADA   | never     |
| daemon  | 🔴 NO SHELL            | N/A          | N/A              | N/A       |
| adm     | 🔴 NO SHELL            | N/A          | N/A              | N/A       |
| ubuntu  | 🟢 SHELL: /bin/bash     | 🟢 ACTIVA     | ✅ DESBLOQUEADA   | 30 days   |



## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/Golidor24/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/Golidor24/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/Golidor24/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/Golidor24/scripts/blob/main/Linux/005-users.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>
