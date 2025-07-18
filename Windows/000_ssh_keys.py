import re
import select
import os
import subprocess
from sys import exit
from tkinter import N

class key_admin:
    """Clase para administrar claves SSH."""
    
    def __init__(self):
        self.ssh_dir = self.get_ssh_directory()
        print(f"Directorio SSH: {self.ssh_dir}")
        self.claves_generadas = []  # Lista para almacenar las claves generadas
    
    def show_keys(self) -> bool:
        """Muestra una lista de las claves SSH en el sistema."""
        try:
            # Listar archivos en el directorio .ssh
            files = os.listdir(self.ssh_dir)
            ssh_keys = [f for f in files if f.endswith('.pub') or f.endswith('id_rsa')]
            
            if not ssh_keys:
                print(f"No se encontraron claves SSH en el directorio {self.ssh_dir}.")
                return False
            
            print("\n--- Claves SSH encontradas ---")
            for key in ssh_keys:
                print(f"- {key}")
            print("-------------------------------")
            return True
        except FileNotFoundError:
            print(f"El directorio {self.ssh_dir} no existe. Asegúrate de que las claves SSH estén generadas.")
            return False
        except Exception as e:
            print(f"Error inesperado al listar las claves SSH: {e}")
            return False
    
    # --------- Bloque generación de claves SSH ---------
    
    def get_key_file_name(self) -> str:
        """Solicita al usuario un nombre de archivo para la clave SSH y valida su existencia.
        Args:
            ssh_dir (str): Ruta del directorio .ssh.
        Returns:
            str: Nombre del archivo de la clave SSH.
        """
        while True:
            while True:
                key_file_name = input("\nIntroduce el nombre de archivo para la clave SSH (Sin extensión)." 
                                "Dejar en blanco para poner nombre por defecto: ").strip()
                # Validar que el nombre del archivo solo contenga caracteres válidos
                if not key_file_name or self.input_char_validate(key_file_name):
                    break
                else:
                    print("El nombre del archivo solo puede contener letras, números, guiones bajos y guiones.")
                    continue
            
            if key_file_name:
                key_path = os.path.join(self.ssh_dir, key_file_name)
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
                    key_path = os.path.join(self.ssh_dir, key_file_name)
                    if not os.path.exists(key_path):
                        print(f"No se ha introducido un nombre de archivo. Usando nombre de archivo por defecto: {key_file_name}")
                        break
                    aux += 1
                break
        return key_file_name

    def get_comment(self) -> str:
        """
        Solicita al usuario un comentario para añadir a la clave, y si es un correo electrónico, valida su formato.
        
        Returns:
            str: comentario de clave SSH.
        """
        comment = input("\nIngrese un comentario que para añadir a la clave SSH, comunmente es un email: ").strip()
        while True:
            # Si el usuario ingresa email, validar el formato del correo electrónico
            if "@" in comment:
                if re.match(r"[^@]+@[^@]+\.[^@]+", comment):
                    return comment
                else:
                    comment = input("Formato de correo electrónico no válido. Por favor, inténtalo de nuevo: ").strip()
            else:
                # Si no es un email, simplemente devolver el comentario
                return comment.strip()   

    def get_passphrase(self) -> str:
        """
        Solicita al usuario una frase de contraseña para la clave SSH.
        
        Returns:
            str: La frase de contraseña ingresada, o '' si el usuario no desea usar una.
        """
        passphrase = input("Introduce una frase de contraseña para la clave SSH (dejar en blanco si no deseas usar una): ").strip()
        if passphrase:
            return passphrase
        else:
            return ""

    def generate_ssh_key(self, email: str, key_name: str, bits: int = 4096, passphrase: str | None = None) -> bool:
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
            
        os.makedirs(self.ssh_dir, exist_ok=True) # Si no existe, crea el directorio .ssh
        print(f"Directorio SSH: {self.ssh_dir}")
        
        
        key_path = os.path.join(self.ssh_dir, key_name)
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
            self.claves_generadas.append({"nombre": key_name, "email": email, "path": key_path, "public_key_path": public_key_path}) # Guarda información de la clave
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
 
    def input_char_validate(self, input_text: str) -> bool:
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

    def key_gen(self) -> bool:
        """Genera una nueva clave SSH."""
        
        # --- Configuración de clave ---
        key_file_name = self.get_key_file_name()
        user_email = self.get_comment()
        user_passphrase = self.get_passphrase()
        
        # --- Generación las claves ---
        print("Iniciando proceso de generación de claves SSH...\n")
        success = self.generate_ssh_key(
            email=user_email,
            key_name=key_file_name,
            passphrase=user_passphrase
        )
        
        if success:
            print("\nGeneración completada. Ahora mostrando la clave pública...")
            # --- Muestra la clave pública ---
            public_key = self.display_public_key(key_file_name)
            if public_key:
                print("\n¡Copia la clave pública de arriba y pégala donde la necesites (ej. GitHub, servidor)!")
                return True
            else:
                return False
        else:
            print("\nHubo un problema en la generación de las claves SSH. Revisa los mensajes de error.")
            return False
   
    # ---------------------------------------------------

    def display_public_key(self, key_name="id_rsa") -> str | None:
        """
        Muestra el contenido de la clave pública SSH por pantalla.

        Args:
            key_name (str): Nombre base del archivo de la clave (ej: id_rsa).
        Returns:
            str or None: El contenido de la clave pública si se encuentra, None en caso contrario.
        """
        pub_key_path = os.path.join(self.ssh_dir, key_name + ".pub")

        if not os.path.exists(pub_key_path):
            print(f"Error: La clave pública no se encontró en {pub_key_path}")
            return None

        try:
            with open(pub_key_path, 'r') as f:
                public_key_content = f.read().strip()
                print("\n------ Contenido de la Clave Pública SSH ------")
                print(public_key_content)
                print("------------------------------------------------")
                return public_key_content
        except Exception as e:
            print(f"Error al leer la clave pública: {e}")
            return None
 
    @staticmethod
    def get_ssh_directory() -> str:
        """Determina la ruta del directorio .ssh según el sistema operativo."""
        
        if os.name == "nt":
            var_entorno = 'USERPROFILE'
            user_profile = os.environ.get(var_entorno)   
        elif os.name == "posix": # Linux, macOS, etc.
            var_entorno = 'HOME'
            user_profile = os.environ.get(var_entorno)
        else:
            raise EnvironmentError("Sistema operativo no soportado. Este script solo funciona en Windows, Linux y macOS. "
                                f"Sistema detectado: {os.name}")
        
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

def main_menu(ka: key_admin) -> None:
    """Muestra un menú de opciones al usuario."""
    
    print("\n--- Bienvenido al generador de claves SSH. ---")
    while True:
        print("\n Por favor, elija la opción deseada:\n")
        print("1. Mostrar lista de claves SSH") # TODO: Implementar más adelante con sub-menú: Editar nombre, eliminar clave, mostrar clave pub, etc.
        print("2. Generar nueva clave SSH") # TODO: Preguntar al finalizar si desea ver la clave pública generada. 
                                            # TODO: También preguntar si desea añadir la clave pública a un servicio como GitHub, GitLab, etc.
        print("3. Generar múltiples claves SSH") # Desde fichero o generadas de forma automática.
        print("4. Añadir clave pública a un servicio (GitHub, GitLab, etc.)") # TODO: Implementar más adelante.
        print("5. Añadir clave(s) al agente SSH") # TODO: Implementar más adelante.
        print("6. Salir")
        
        while True:
            opción = input("Selecciona una opción: ").strip()
            if not re.match(r"^\d+$", opción):
                print("Por favor, ingresa un número válido para la opción.")
                continue
            break
        
        match int(opción):
            case 1:
                ka.show_keys()  # Llama al método para mostrar las claves SSH
            case 2:
                ka.key_gen()  # Llama al método para generar una clave SSH
            case 3:
                return None  # Implementar más adelante
            case 4:
                return None  # Implementar más adelante
            case 5:
                return None  # Implementar más adelante
            case 6:
                return exit("Saliendo del generador de claves SSH. ¡Hasta luego!")
            case _:
                print("Seleccione una opción correcta basada en el número indicado a su izquierda.")


if __name__ == "__main__":
    
    ka = key_admin() # Crear instancia de la clase key_admin 
    
    status = main_menu(ka)