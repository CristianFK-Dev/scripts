# Script para monitorear uno o mas procesos al mismo tiempo

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

> ⚠️ **Este script necesita de permisos elevados para su ejecución.**  
> Usalo con precaución, especialmente en entornos de producción.  
> ✅ Siempre revisá el código antes de ejecutarlo.

---

## ✨ Descripción

Este script (`008-proc-monitor.sh`) permite monitorear el uso de CPU y memoria de procesos en Linux durante un período de tiempo definido por el usuario. Se puede seleccionar entre todos los procesos, solo los de sistema (root) o solo los de usuario. El monitoreo se guarda en un log para su posterior revisión.

---

## 🛠️ Requisitos

- Distribución **Linux** con `systemd`.
- Permisos de **root** (`sudo`).
- Herramientas básicas como `ps`, `awk`, `bash`.

---

## 🚀 Uso

### 📥 Descargar y ejecutar:

```bash
curl -O https://raw.githubusercontent.com/CristianFK-Dev/scripts/main/Linux/008-proc-monitor.sh

chmod +x bash 008-proc-monitor.sh

sudo bash 008-proc-monitor.sh
```

---

> **Nota:** Es recomendable ejecutarlo como root para poder ver todos los procesos.

---

## Menú principal

- **1**: Listar todos los procesos.
- **2**: Listar solo procesos de sistema (root).
- **3**: Listar solo procesos de usuario (UID >= 1000).
- **l**: Ver el log con `less`.
- **s**: Salir del script.

---

## Procedimiento

1. **Seleccionar tipo de procesos**  
   Elige si deseas ver todos los procesos, solo los de sistema o solo los de usuario.

2. **Seleccionar procesos a monitorear**  
   Se muestra una lista numerada. Ingresa los números de los procesos que deseas monitorear (separados por espacio).

3. **Definir duración**  
   Indica cuántos segundos deseas monitorear los procesos seleccionados.

4. **Elegir formato de salida**  
   - **1**: Resumido (PID, CPU, MEM)
   - **2**: Completo (PID, CPU, MEM, RSS, CMD)

5. **Monitoreo**  
   El script muestra el monitoreo en pantalla y lo guarda en `/var/log/008-proc-monitor.log`.

6. **Ver logs**  
   Desde el menú principal, selecciona `l` para ver el log con `less`. Sal con `q` para volver al menú.

---

## 💡 Ejemplo de uso

```bash
sudo bash 008-proc-monitor.sh
# Selecciona "1" para todos los procesos
# Elige los números de los procesos a monitorear (ej: 2 5 7)
# Ingresa la duración (ej: 10)
# Selecciona el formato (1 o 2)
```

---

## Log

- El log se guarda en: `/var/log/008-proc-monitor.log`
- Incluye fecha, hora, PID, nombre del proceso, uso de CPU y memoria, y comando completo (si se elige formato completo).

---

## Salida de ejemplo

```
2025-09-07 15:30:00 ----INICIO------------------------------------------------------------------------------------------------
[2025-09-07 15:30:01] bash (PID 1234) CPU: 0.0% MEM: 0.1%
[2025-09-07 15:30:01] python3 (PID 5678) CPU: 1.2% MEM: 2.3%
...
2025-09-07 15:30:10 ----FIN--Se monitorearon 10 segundos---------------------------------------------------------------------
```

---

## 🧠 ¿Por qué usar este script?

- Permite monitorear de forma sencilla y rápida el consumo de recursos de procesos específicos, sin depender de herramientas gráficas.
- Es útil para detectar procesos que consumen mucha CPU o memoria y así anticipar problemas de rendimiento.
- Facilita la auditoría y el troubleshooting en servidores o entornos de producción.
- El log generado permite analizar el comportamiento de los procesos a lo largo del tiempo.
- Es ideal para administradores de sistemas, desarrolladores y usuarios avanzados que buscan una solución ligera y personalizable.

## 📤 Compartir este script

<p align="center">
    <a href="https://www.reddit.com/submit?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/008-proc-monitor.sh">
        <img src="https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white" alt="Reddit" />
    </a>
    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/008-proc-monitor.sh">
        <img src="https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin" alt="LinkedIn" />
    </a>
    <a href="https://wa.me/?text=Revisá%20este%20script:%20https://github.com/CristianFK-Dev/scripts/blob/main/Linux/008-proc-monitor.sh">
        <img src="https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white" alt="WhatsApp" />
    </a>
    <a href="https://t.me/share/url?url=https://github.com/CristianFK-Dev/scripts/blob/main/Linux/008-proc-monitor.sh">
        <img src="https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white" alt="Telegram" />
    </a>
</p>

