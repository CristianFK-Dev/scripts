## 🛠️ Linux and Windows Catalog Scripts

Descarga la colección completa:
- `git clone https://github.com/CristianFK-Dev/scripts.git`

Colección de scripts Bash / Python para automatizar la configuración, instalaciòn, mantenimiento y uso de aplicaciones en sistemas operativos Linux y Windows. 
Ideal para administradores de sistemas, entornos de testing, laboratorios o despliegues rápidos.
- `Cada script contiene la documentaciòn sobre su funcionamiento.`

---

## 📌 Características

- Instalación de paquetes esenciales
- Configuración de red y hostname
- Configuración de usuarios y claves SSH
- Aplicación de hardening básico (según CIS benchmarks)
- Configuración de firewall (`ufw`, `iptables`, `firewalld`)
- Personalización de MOTD y alias
- Plantillas reutilizables para `sshd_config`, `sysctl.conf`, etc.

---

## 🖥️ Sistemas operativos soportados

- 🐧 Debian 10/11/12
- 🐧 Ubuntu 20.04/22.04
- 🪟 Windows 10/11

---

## 🤚🏽 Permisos y ejecución LINUX

- Dar los permisos para ejecución:`chmod +x script.sh`
- Ejecutar como root o con sudo: `sudo ./script.sh` o `sudo bash script.sh`

---

## 📋 Lista de scripts LINUX🐧

| N° | Script | Documentación | Estado |
|---:|---------------|:-------------:|:----:|
| 000|[User check](Linux/000-user-check.sh) | [README](Linux/Docs/000-user-check.md) | ✅ Terminado ✅ |
| 001|[APT upgrade](Linux/001-apt-upgrade.sh) | [README](Linux/Docs/001-apt-upgrade.md) | ✅ Terminado ✅ |
| 002|[Kernel modules](Linux/002-mod-kernel.sh) | [README](Linux/Docs/002-mod-kernel.md) | ✅ Terminado ✅ |
| 003|[Filse system disable](Linux/003-filesystems-disable.sh) | [README](Linux/Docs/003-filesystems-disable.md) | ✅ Terminado ✅ |
| 004|[Password security check](Linux/004-pass-check.sh) | [README](Linux/Docs/004-pass-check.md) | 🚧 WIP 🚧 |
| 005|[Users status](Linux/005-users.sh) | [README](Linux/Docs/005-users.md) | ✅ Terminado ✅ |
| 006|[Active service manager](Linux/006-service-systemd-active.sh) | [README](Linux/Docs/006-service-systemd-active.md) | ✅ Terminado ✅ |
| 007|[Inactive service manager](Linux/007-service-systemd-inactive.sh) | [README](Linux/Docs/007-service-systemd-inactive.md) | ✅ Terminado ✅ |

---

## 📋 Lista de scripts Multisistema

| N° | Script | Documentación | Tipo | Win🪟 | Linux🐧 | MacOS🍎 | Estado |
|---:|---------------|:-------------:|:----:|:----:|:----:|:----:|:----:|
| 000| [SSH Keys admin](Windows/000_ssh_keys.py) | [README](Windows/Docs/000_ssh_keys.md) | Consola | ✅ | ✅ | ✅ |🚧 WIP 🚧 |
| 001| [SSH Keys admin](Windows/001/001_ssh_keys_desktop.py) | ------ | Escritorio | ✅ | ✅ | ✅ |🚧 WIP 🚧 |



---


## 🙋 Desarrollado por:

- Pablo S.F.K.
- 📧 contacto: [pablosfk@gmail.com]

- Cristian F.K.
- 📧 contacto: [cfk2424@gmail.com]
- 🔗 LinkedIn: [https://www.linkedin.com/in/cristian-fk/] 
