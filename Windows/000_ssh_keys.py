import re
import subprocess
import os
import platform

def get_ssh_directory() -> str:
    """Determina la ruta del directorio .ssh según el sistema operativo."""
    if os.name == "nt":
        var_entorno = 'USERPROFILE'
        user_profile = os.environ.get(var_entorno)   
    elif os.name == "posix": # Linux, macOS, etc.
        var_entorno = 'HOME'
        user_profile = os.environ.get(var_entorno)
    else:
        raise EnvironmentError(f"Sistema operativo no soportado. Este script solo funciona en Windows, Linux y macOS. "
                               "Sistema detectado: {platform.system()}")
    
    try:
        if not user_profile:
            raise EnvironmentError(f"No se pudo encontrar la variable de entorno {var_entorno}. "
                                    "Asegúrate de que estás ejecutando el script en un entorno de usuario válido.")
        ssh_path = os.path.join(user_profile, '.ssh')
        if not ssh_path:
            raise EnvironmentError("No se pudo determinar el directorio .ssh en Windows.")    
    except KeyError:
        raise EnvironmentError("No se pudo encontrar la variable de entorno USERPROFILE. "
                                "Asegúrate de que estás ejecutando el script en un entorno de usuario válido.")            
    except Exception as e:
        raise EnvironmentError(f"Error inesperado al determinar el directorio .ssh en Windows: {e}")
    
    return ssh_path

def generate_ssh_key(email: str, key_name: str, bits: int = 4096, passphrase: str | None = None) -> bool:
    """
    Genera un par de claves SSH (privada y pública).

    Args:
        email (str): Comentario para la clave (generalmente tu email).
        key_name (str): Nombre base del archivo de la clave.
        bits (int): Tamaño de la clave en bits (por defecto 4096).
        passphrase (str): Frase de contraseña para la clave privada. Si es None, no se usará.
    Returns:
        bool: True si la generación fue exitosa, False en caso contrario.
    """
    ssh_dir = get_ssh_directory()
    
    os.makedirs(ssh_dir, exist_ok=True) # Si no existe, crea el directorio .ssh
    print(f"Directorio SSH: {ssh_dir}")
    
    
    key_path = os.path.join(ssh_dir, key_name)
    public_key_path = key_path + ".pub"

    print(f"Intentando generar claves SSH en: {key_path}")

    # Comando base para ssh-keygen
    command = ["ssh-keygen", "-t", "rsa", "-b", str(bits), "-C", email, "-f", key_path]

    # Añadir passphrase si se proporciona
    if passphrase:
        command.extend(["-N", passphrase])
    else:
        command.extend(["-N", ""])

    try:
        # Ejecutar el comando
        process = subprocess.run(command, capture_output=True, text=True, check=True)
        print("Salida de ssh-keygen (stdout):\n", process.stdout)
        if process.stderr:
            print("Errores de ssh-keygen (stderr):\n", process.stderr)
        print(f"Claves SSH generadas exitosamente en:\nClave: {key_path}\nClave Pública: {public_key_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error al generar claves SSH: {e}")
        print("Salida de error (stdout):\n", e.stdout)
        print("Salida de error (stderr):\n", e.stderr)
        return False
    except FileNotFoundError:
        print("Error: 'ssh-keygen' no encontrado. Asegúrate de tener OpenSSH Client instalado o Git Bash.")
        print("En Windows, verifica que la característica opcional 'Cliente OpenSSH' esté instalada o que Git Bash esté en tu PATH.")
        return False
    except Exception as e:
        print(f"Error inesperado al generar claves SSH: {e}")
        return False

def display_public_key(key_name="id_rsa") -> str | None:
    """
    Muestra el contenido de la clave pública SSH por pantalla.

    Args:
        key_name (str): Nombre base del archivo de la clave (ej: id_rsa).
    Returns:
        str or None: El contenido de la clave pública si se encuentra, None en caso contrario.
    """
    ssh_dir = get_ssh_directory()
    pub_key_path = os.path.join(ssh_dir, key_name + ".pub")

    if not os.path.exists(pub_key_path):
        print(f"Error: La clave pública no se encontró en {pub_key_path}")
        return None

    try:
        with open(pub_key_path, 'r') as f:
            public_key_content = f.read().strip()
            print("\n--- Contenido de la Clave Pública SSH ---")
            print(public_key_content)
            print("------------------------------------------")
            return public_key_content
    except Exception as e:
        print(f"Error al leer la clave pública: {e}")
        return None

def input_char_validate(input_text: str) -> bool:
    """
    Valida la entrada del usuario para aceptar solo caracteres válidos.

    Args:
        input_text (str): Texto de entrada del usuario.
    Returns:
        bool: Si fue válido o no.
    """
    valid_chars = "abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789_-"
    if all(char in valid_chars for char in input_text):
        return True
    else:
        return False

if __name__ == "__main__":
    
    ssh_dir = get_ssh_directory()
    
    # --- Configuración del usuario ---
    print("\nBienvenido al generador de claves SSH. Por favor, proporciona la siguiente información:")
    while True:
        while True:
            key_file_name = input("\nIntroduce el nombre de archivo para la clave SSH (Sin extensión)." 
                              "Dejar en blanco para poner nombre por defecto: ").strip()
            # Validar que el nombre del archivo solo contenga caracteres válidos
            if not key_file_name or input_char_validate(key_file_name):
                break
            else:
                print("El nombre del archivo solo puede contener letras, números, guiones bajos y guiones.")
                continue
        
        if key_file_name:
            key_path = os.path.join(ssh_dir, key_file_name)
            if os.path.exists(key_path):
                sobrescribe = input(f"El archivo {key_path} ya existe. ¿Deseas sobrescribirlo? (s/n): \n").strip().lower()
                if sobrescribe in ['s','si', 'yes', 'y']:
                    print(f"Eliminando el archivo existente: {key_path}")
                    os.remove(key_path)
                    os.remove(key_path + ".pub")  # Eliminar también la clave pública si existe
                    break
                elif sobrescribe in ['n', 'no']:
                    print("Por favor, elige un nombre diferente.")
                    continue
                else:
                    print("Opción no válida. Por favor, responde con 's' o 'n'.")
                    continue
            break
        else:
            aux = 0
            while True:
                key_file_name = f"mi_clave_ssh_{aux}"
                key_path = os.path.join(ssh_dir, key_file_name)
                if not os.path.exists(key_path):
                    print(f"No se ha introducido un nombre de archivo. Usando nombre de archivo por defecto: {key_file_name}")
                    break
                aux += 1
            break
                        
    user_email = "tu_email@midominio.com" #input("Introduce tu comentario para la clave SSH (tradicionalmente un email): ")
    user_passphrase = "ElQueTengaMiedoAMorirQueNoNazca" # Frase segura o None #input("Introduce una frase de contraseña para la clave privada (deja en blanco si no deseas usar una): ")

    # --- Generar las claves ---
    print("Iniciando proceso de generación de claves SSH...\n")
    success = generate_ssh_key(
        email=user_email,
        key_name=key_file_name,
        passphrase=user_passphrase
    )

    if success:
        print("\nGeneración completada. Ahora mostrando la clave pública...")
        # --- Mostrar la clave pública ---
        public_key = display_public_key(key_file_name)
        if public_key:
            print("\n¡Copia la clave pública de arriba y pégala donde la necesites (ej. GitHub, servidor)!")
    else:
        print("\nHubo un problema en la generación de las claves SSH. Revisa los mensajes de error.")
