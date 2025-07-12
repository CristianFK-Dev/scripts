# Script para Administración de Claves SSH

<p align="center">
    <a href="https://docs.python.org/3/">
        <img src="https://img.shields.io/badge/Lenguaje-Python%203.13-739120?style=flat&labelColor=363D44" alt="Lenguaje">
    </a>
    <img src="https://img.shields.io/badge/OS-Windows%20%7C%20Linux%20%7C%20MacOS-blue?style=flat&logoColor=b0c0c0&labelColor=363D44" alt="Sistemas operativos">
</p>

## Recomendaciones

⚠️ **Advertencia de Seguridad Importante** ⚠️

Por cuestiones de seguridad, recomendamos encarecidamente que lea el contenido de este o cualquier script antes de ejecutarlo en su computadora, en especial si lo va a correr directamente de forma online; o bien puede pasarle el script o incluso la url del repositorio a alguna IA para que corrobore por usted que está libre de cualquier amenaza. 

## Ejecución

Este es un script, y como tal no necesita ser instalado, sino más bien ejecutado. La opción recomendada es **descargar y ejecutar**.
Esta es la forma más segura y funcional para este script interactivo. Te permite revisar el código antes de ejecutarlo y asegura que el script pueda pedirte información durante su ejecución.

### Descarga y ejecución local 💻
Para descargar el script desde `GitHub` de forma manual, puedes ir a la ruta del [**script**](../ssh_keys.py) y hacer clic en el ícono de descarga <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="18" height="18"><path fill="currentcolor" d="M7.47 10.78a.749.749 0 0 0 1.06 0l3.75-3.75a.749.749 0 1 0-1.06-1.06L8.75 8.439V1.75a.75.75 0 0 0-1.5 0v6.689L4.78 5.97a.749.749 0 1 0-1.06 1.06l3.75 3.75ZM3.75 13a.75.75 0 0 0 0 1.5h8.5a.75.75 0 0 0 0-1.5h-8.5Z"/></svg> arriba a la derecha y ejecutarlo por consola como mostraremos más adelante.

Para su descarga de forma remota por consola:

1.  **Abre tu terminal** (CMD o PowerShell en Windows, o Terminal en Linux/macOS, o bash en cualquier caso).

2.  **Navega al directorio** donde deseas guardar el script (por ejemplo, `cd ~/Descargas` o `cd C:\Users\TuUsuario\Documents`en **Windows**, `cd ~/Downloads` o `cd ~/Documentos` en **Linux** y **macOS**).

3.  **Descarga del script:**

    * **Para Windows (CMD o PowerShell):**

        ```powershell
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Golidor24/scripts/refs/heads/main/Windows/ssh_keys.py" -OutFile "ssh_keys.py"
        ```
        O si tienes `curl` disponible:

        ```cmd
        curl -o ssh_keys.py https://raw.githubusercontent.com/Golidor24/scripts/refs/heads/main/Windows/ssh_keys.py
        python ssh_keys.py
        ```
    * **Para Linux y macOS (Terminal/Bash):**
        ```bash
        curl -O https://raw.githubusercontent.com/Golidor24/scripts/main/Windows/ssh_keys.py
        ```
        O si prefieres `wget`:
        ```bash
        wget https://raw.githubusercontent.com/Golidor24/scripts/main/Windows/ssh_keys.py
        ```

4.  **Ejecuta el script (una vez descargado):**

    * **Para Windows:**
        ```bash
        python ssh_keys.py
        ```

    * **Para Linux/macOS:**
        ```bash
        python3 ssh_keys.py
        ```
        (Usa `python` si `python3` no funciona y sabes que tu sistema usa Python 3 por defecto con ese comando).

## Consideraciones a tener en cuenta 👷 

🚧 Trabajando 🚧

 
[![Share GitHub](https://img.shields.io/badge/Compartir-181717?logo=github&logoColor=white)](https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py)
[![Share Stack Overflow](https://img.shields.io/badge/Compartir-FE7A16?logo=stackoverflow&logoColor=white)](https://stackoverflow.com/search?q=Golidor24%20scripts%20python)
[![Share Reddit](https://img.shields.io/badge/Compartir-FF4500?logo=reddit&logoColor=white)](https://www.reddit.com/submit?title=Check%20out%20this%20project%20on%20GitHub:%20https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py)
[![Share dev.to](https://img.shields.io/badge/Compartir-0A0A0A?logo=dev.to&logoColor=white)](https://dev.to/search?q=Golidor24%20python%20scripts)
[![Share Discord](https://img.shields.io/badge/Compartir-5865F2?logo=discord&logoColor=white)](https://discord.gg/your-invite-link)
[![Share LinkedIn](https://img.shields.io/badge/LinkedIn-Compartir-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py)
[![Share X](https://img.shields.io/badge/Compartir-000000?logo=x&logoColor=white)](https://x.com/intent/tweet?text=Hecha%20un%20vistazo%20a%20este%20proyecto:%20https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py%20%23SSH%20%23Script)
[![Share WhatsApp](https://img.shields.io/badge/Compartir-25D366?logo=whatsapp&logoColor=white)](https://wa.me/?text=Hecha%20un%20vistazo%20a%20este%20proyecto:%20https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py)
[![Share Telegram](https://img.shields.io/badge/Compartir-0088CC?logo=telegram&logoColor=white)](https://t.me/share/url?url=https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.pytext=Hecha%20un%20vistazo%20a%20este%20proyecto)
[![Share Facebook](https://img.shields.io/badge/Compartir-1877F2?logo=facebook&logoColor=white)](https://www.facebook.com/sharer/sharer.php?u=https://github.com/Golidor24/scripts/blob/main/Windows/ssh_keys.py)