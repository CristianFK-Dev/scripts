import re
import os
import subprocess
from sys import exit
from tkinter import N

class key_admin:
    """Clase para administrar claves SSH."""
    
    def __init__(self):
        self.ssh_dir = self.get_ssh_directory()
        self.csv_dir = os.path.join(os.getcwd(), 'CSV')  # Directorio CSV en el directorio actual
        if not os.path.exists(self.csv_dir):
            os.makedirs(self.csv_dir)  # Crear el directorio CSV si no existe
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
            print(f"Directorio: {self.ssh_dir}\n")
            for index, key in enumerate(ssh_keys, start=1):
                print(f"{index}. {key}")
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
                key_file_name = self.generador_de_nombres()
                break
        return key_file_name

    def generador_de_nombres(self) -> str:
        """
        Genera un nombre de archivo por defecto para la clave SSH.
        
        Returns:
            str: Nombre de archivo por defecto.
        """
        aux = 0
        while True:
            key_file_name = f"mi_clave_ssh_{aux}"
            key_path = os.path.join(self.ssh_dir, key_file_name)
            if not os.path.exists(key_path):
                print(f"No se ha introducido un nombre de archivo. Usando nombre de archivo por defecto: {key_file_name}")
                break
            aux += 1
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

    def generate_ssh_key(self, key_name: str, email: str, bits: int = 4096, passphrase: str | None = None) -> bool:
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

        print(f"Generando claves SSH en: {key_path}")

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
            #print("Salida de ssh-keygen (stdout):\n", process.stdout)
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
            key_name=key_file_name,
            email=user_email,
            passphrase=user_passphrase
        )
        
        if success:
            print("\nGeneración completada. Ahora mostrando la clave pública...")
            # --- Muestra la clave pública ---
            public_key = self.display_public_key(key_file_name)
            if public_key:
                self.copy_to_clipboard(public_key)
                print("¡Pega la clave donde la necesites (ej. GitHub, servidor)!")
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
    
    def copy_to_clipboard(self, text: str) -> None:
        """Copia el texto proporcionado al portapapeles."""
        # Lo haremos usando librerías integradas de Python, no pyperclip, para evitar dependencias externas.
        try:
            import tkinter as tk
            root = tk.Tk()
            root.withdraw()  # Oculta la ventana principal
            root.clipboard_clear()  # Limpia el portapapeles
            root.clipboard_append(text)  # Añade el texto al portapapeles
            root.update()  # Actualiza el portapapeles
            print("\nClave pública copiada al portapapeles.")
        except Exception as e:
            print(f"Error al copiar la clave pública al portapapeles: {e}")
            return None
        

    
    @staticmethod
    def abrir_link_web(url):
        """
        Abre una URL en el navegador web predeterminado del sistema.
        """
        
        import webbrowser
        
        try:
            webbrowser.open(url)
            print(f"Abriendo el vínculo: {url}")
        except Exception as e:
            print(f"No se pudo abrir el vínculo: {url}. Error: {e}")
    
    # Se abrirá cada archivo CSV en el directorio CSV y se generarán las claves SSH automáticamente.
    
    def multi_key_gen(self) -> None:
        """
        Genera múltiples claves SSH de forma automática o desde un fichero.
        
        El fichero debe estar en formato CSV, sin importar su nombre, ubicado en 
        un directorio CSV dentro del directorio raíz del script:
        
        Directorio raíz/
        ├── 000_ssh_keys.py
        └── CSV/
            ├── claves_ssh_1.csv
            ├── claves_ssh_2.csv
            ├── ...
            ├── desarrollo.csv
            ├── contabilidad.csv
            └──...
           
        y con los siguientes campos dentro de cada archivo CSV:
        
        - Nombre de la clave
        - Email (comentario)
        - Frase de contraseña (opcional)
        - Tamaño de la clave en bits (opcional)
        
        El formato CSV debe ser de la siguiente manera:
        nombre_clave_1,email1,frase_contraseña_1,tamaño_bits_1
        nombre_clave_2,email2,frase_contraseña_2,tamaño_bits_2
        ...
        
        Ejemplo:
        mi_clave_ssh,mi_email@gmail.com,mi_frase_contraseña,4096
        
        nombre_clave: Son válidas letras, números, guiones bajos y guiones.
        email: Debe ser un comentario válido, generalmente un correo electrónico, el cuál se verificará su formato.
        frase_contraseña: Puede ser una cadena de texto o dejarse en blanco.
        tamaño_bits: Puede ser un número entero o dejarse en blanco, en cuyo caso se usará el valor por defecto de 4096 bits.
        
        Si el fichero no existe o no se puede leer, se mostrará un mensaje de error.
        Si hay más de un archivo CSV en el directorio raíz del script, se procesarán todos.
        """
        
        import csv
        
        def cargar_csv(nombre_archivo: str) -> list:
            """
            Carga un archivo CSV en una lista de listas.

            Args:
                nombre_archivo (str): La ruta al archivo CSV. 

            Returns:
                list: Una lista de listas, donde cada lista interna representa una fila del CSV.
                      Retorna una lista vacía si el archivo no existe o está vacío.
            """
            ruta_archivo = os.path.join(self.csv_dir, nombre_archivo) 
            data = []
            try:
                with open(ruta_archivo, 'r', newline='', encoding='utf-8') as archivo_csv:
                    lector_csv = csv.reader(archivo_csv)
                    for fila in lector_csv:
                        data.append(fila)
            except FileNotFoundError:
                print(f"Error: El archivo '{nombre_archivo}' no fue encontrado en {self.csv_dir}. <-------<<<")
            except Exception as e:
                print(f"Ocurrió un error inesperado al leer el archivo CSV: {e} <-------<<<")
            return data
        
        # --- Verificar si el directorio CSV existe y tiene archivos, y enlista los .csv encontrados ---
        if not os.path.exists(self.csv_dir):
            print(f"El directorio {self.csv_dir} no existe. Por favor, crea el directorio y coloca los archivos CSV necesarios.\n")
            return None
        csv_files = [f.lower() for f in os.listdir(self.csv_dir) if f.lower().endswith('.csv')]
        # --- Por cada archivo CSV encontrado, se generarán las claves SSH ---
        if csv_files:
            print(f"\nArchivos CSV encontrados en {self.csv_dir}: \n{', '.join(csv_files)}\n")
            for CSV in csv_files:
                print(f"Procesando el archivo CSV: {CSV}")
                print("-----------------------------------")
                data = cargar_csv(CSV)
                if not data:
                    print(f"No se encontraron datos en el archivo {CSV}. Asegúrate de que el formato sea correcto.\n")
                    continue
                else:
                    for new_key in data:
                        if len(new_key) < 2:
                            print(f"Error: La línea {new_key} en el archivo {CSV} no tiene suficientes campos. "
                                  "Debe tener al menos nombre de clave y email (comentario)."
                                  "ADVERTENCIA: Esta clave es ignorada por el generador, ingrésela manualmente luego de corregirla.")
                            continue
                        key_name = new_key[0].strip()
                        # Si existe un nombre de clave, se verifica que no exista ya en el directorio .ssh, de ser así, se borra la antigua clave SSH y su .pub
                        if key_name:
                            key_path = os.path.join(self.ssh_dir, key_name)
                            if os.path.exists(key_path):
                                print(f"\nEl archivo {key_path} ya existe. Se pasa a sobrescribirlo.")
                                os.remove(key_path)
                                os.remove(key_path + ".pub")
                        else:
                            key_name = self.generador_de_nombres()
                        email = new_key[1].strip()
                        if len(new_key) > 2:
                            try:
                                bits = int(new_key[2].strip())
                                passphrase = new_key[3].strip() if len(new_key) > 3 else ""
                            except Exception:
                                passphrase = new_key[2].strip()
                                try:
                                    bits = int(new_key[3].strip()) if len(new_key) > 3 else 4096
                                except Exception:
                                    bits = 4096
                        else:
                            bits = 4096
                            passphrase = ""
                        
                        print(f"\nGenerando clave SSH del fichero {CSV}: {key_name}, Email: {email}, Frase de contraseña: {passphrase}, Bits: {bits}")
                        self.generate_ssh_key(key_name, email, bits, passphrase)
    
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
        print("\n--- Por favor, elija la opción deseada:\n")
        print("1. Mostrar lista de claves SSH") # TODO: Implementar más adelante con sub-menú: Editar nombre, eliminar clave, mostrar clave pub, etc.
        print("2. Generar nueva clave SSH") # TODO: Preguntar al finalizar si desea ver la clave pública generada. 
                                            # TODO: También preguntar si desea añadir la clave pública a un servicio como GitHub, GitLab, etc.
        print("3. Generar múltiples claves SSH desde CSV. (Ver documentación, opción 6)") # Desde fichero o generadas de forma automática.
        print("4. Añadir clave pública a un servicio (GitHub, GitLab, etc.)") # TODO: Implementar más adelante.
        print("5. Añadir clave(s) al agente SSH") # TODO: Implementar más adelante.
        print("6. Documentación y ayuda: github.com/Golidor24/scripts/blob/main/Windows/Docs/000_ssh_keys.md")
        print("7. Salir")
        
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
                ka.multi_key_gen()  # Llama al método para generar múltiples claves SSH
            case 4:
                return None  # Implementar más adelante
            case 5:
                return None  # Implementar más adelante
            case 6:
                ka.abrir_link_web("https://github.com/Golidor24/scripts/blob/main/Windows/Docs/000_ssh_keys.md")
            case 7:
                return exit("\nSaliendo del generador de claves SSH. ¡Hasta luego!\n")
            case _:
                print("\nSeleccione una opción correcta basada en el número indicado a su izquierda.")


if __name__ == "__main__":
    
    ka = key_admin() # Crear instancia de la clase key_admin 
    
    status = main_menu(ka)