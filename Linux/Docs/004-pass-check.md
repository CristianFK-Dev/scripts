# Script evaluación de seguridad de contraseñas

<p align="center">
    <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">
        <img src="https://img.shields.io/badge/Lenguaje-Bash-4EAA25?style=flat&logo=gnubash&labelColor=363D44" alt="Lenguaje">
    </a>
    <a href="https://www.debian.org/">
        <img src="https://img.shields.io/badge/OS-Linux%20%7C%20Debian-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
    </a>
</p>

---

## 🛡️ Evaluador de Contraseñas por Complejidad

> Este script estima la **fuerza y resistencia teórica** de una contraseña a ataques de fuerza bruta  
> en función de su composición: letras, números, símbolos y longitud total.

---

## 🧾 Descripción

Este script:

- ✅ Toma una contraseña como entrada
- 🔍 La analiza por tipo de caracteres (mayúsculas, minúsculas, dígitos y símbolos)
- 📊 Calcula el espacio total de búsqueda de combinaciones posibles
- ⏱️ Estima el tiempo requerido para romperla a cierta velocidad (brute-force)
- 📉 Clasifica su resistencia (Débil / Media / Fuerte / Excelente)

Ideal para uso educativo, auditorías rápidas o tareas de hardening.

---

## 🛠️ Requisitos

- Bash
- Linux o WSL
- Opcional: `bc` para cálculos más precisos

---

## 🚀 Uso

### 📥 Descargar y ejecutar

```bash
curl -O https://raw.githubusercontent.com/Golidor24/scripts/main/Linux/004-pass-check.sh

chmod +x 004-pass-check.sh

./004-pass-check.sh.sh

```

## 💡 Ejemplo de uso


🛡️ Análisis de Contraseña

Ingrese la contraseña a evaluar: **********

📊 Caracteres detectados:
  - Mayúsculas: 1
  - Minúsculas: 5
  - Dígitos:     4
  - Símbolos:    2

🔐 Longitud total: 12
🔢 Espacio de búsqueda: 72^12 ≈ 1.9e+22 combinaciones

⏳ Tiempo estimado para romperla a 1e9 intentos/seg: ~600 años

✅ Clasificación: Excelente


