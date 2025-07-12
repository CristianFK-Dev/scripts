# 🚀 001-update.sh - Gestor de Actualizaciones APT Interactivo

Este script de Bash es una herramienta sencilla y robusta para **gestionar las actualizaciones de paquetes en sistemas basados en Debian/Ubuntu (usando APT)**. Ofrece una forma interactiva de actualizar la lista de paquetes, ver cuáles están disponibles para actualizar y seleccionar específicamente cuáles quieres instalar, o bien, instalarlos todos de una vez.

## ✨ Características Principales

* **Actualización de Índice de Paquetes**: Ejecuta `apt update` para asegurarse de que tenés la información más reciente sobre los paquetes disponibles.
* **Listado Interactivo**: Muestra una lista numerada y clara de todos los paquetes que tienen actualizaciones pendientes.
* **Selección Flexible**:
    * Podés elegir **uno o varios paquetes** para actualizar ingresando sus números (ej: `1 3 5`).
    * Podés optar por actualizar **todos los paquetes** disponibles con una simple opción (`a`).
* **Instalación Controlada**: Solo se instalan los paquetes que vos seleccionaste explícitamente.
* **Informe Final**: Al terminar, te muestra una lista de los paquetes que se instalaron y sus versiones actuales.
* **Validación de Permisos**: Asegura que el script se ejecute con permisos de root, vital para operaciones de `apt`.

## 🛠️ Requisitos

* Un sistema operativo basado en **Debian o Ubuntu** (o cualquier distribución que use `apt`).
* Permisos de **root** para ejecutar el script (se usa `sudo`).

## 🚀 Uso

1.  **Guardar el script**: Guardá el código en un archivo, por ejemplo, `001-update.sh`.
2.  **Dar permisos de ejecución**: Abrí tu terminal y navegá hasta la carpeta donde guardaste el script. Luego, ejecutá:
    ```bash
    chmod +x 001-update.sh
    ```
3.  **Ejecutar el script**: Siempre ejecutalo con `sudo`:
    ```bash
    sudo ./001-update.sh
    ```

### Ejemplos de Interacción:

Después de que el script actualice la lista de paquetes y te muestre los disponibles, te pedirá que elijas:

  ```
  📦 Paquetes que se pueden actualizar:
   1. nano
   2. brave-browser
   3. vlc
   4. imagemagick
  
  👉 Ingresá los números de los paquetes a instalar (separados por espacio), o 'a' para todos:
  Tu elección:
  
  ```

* **Para instalar un solo paquete (ej. `nano`):**
    ```
    Tu elección: 1
    ```
* **Para instalar varios paquetes (ej. `nano` y `vlc`):**
    ```
    Tu elección: 1 3
    ```
* **Para instalar todos los paquetes disponibles:**
    ```
    Tu elección: a
    ```

## 💡 ¿Por qué usar este script?

Aunque podés hacer `sudo apt upgrade`, este script te da un **control más granular** sobre tus actualizaciones. Es ideal si querés:

* **Revisar qué se va a actualizar** antes de hacerlo.
* **Evitar actualizar todo** a la vez si tenés problemas de compatibilidad o si solo necesitás actualizar ciertos componentes.
* Tener una **confirmación visual** de las versiones instaladas al finalizar.

---

