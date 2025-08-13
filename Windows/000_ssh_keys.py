import re
import os
import subprocess
from sys import exit
from winreg import KEY_ENUMERATE_SUB_KEYS

class key_admin:
    """Clase para administrar claves SSH."""
    
    def __init__(self):
        self.ssh_dir = self.get_ssh_directory()
        self.csv_dir = os.path.join(os.getcwd(), 'CSV')  # Directorio CSV en el directorio actual
        if not os.path.exists(self.csv_dir):
            os.makedirs(self.csv_dir)  # Crear el directorio CSV si no existe
        print(f"Directorio SSH: {self.ssh_dir}")
        self.claves_generadas = []  # Lista para almacenar las claves generadas
    
    def show_keys(self) -> list:
        """Muestra una lista de las claves SSH en el sistema."""
        try:
            # Listar archivos en el directorio .ssh
            files = os.listdir(self.ssh_dir)
            ssh_keys = [f for f in files if f.endswith('.pub') or f.endswith('id_rsa')]
            
            if not ssh_keys:
                print(f"No se encontraron claves SSH en el directorio {self.ssh_dir}.")
                return []
            
            print("\n--- Claves SSH encontradas ---")
            print(f"Directorio: {self.ssh_dir}\n")
            for index, key in enumerate(ssh_keys, start=1):
                print(f"{index}. {key}")
            print("-------------------------------")
            return ssh_keys
        except PermissionError:
            print(f"No tienes permiso para acceder al directorio {self.ssh_dir}.")
            return []
        except FileNotFoundError:
            print(f"El directorio {self.ssh_dir} no existe. Asegúrate de que las claves SSH estén generadas.")
            return []
        except Exception as e:
            print(f"Error inesperado al listar las claves SSH: {e}")
            return []
    
    def greetings(self) -> None:
        """Saludo inicial al usuario."""
        print('▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒')
        print('▒╔═══╦═══╦╗▒╔╗▒╔╗╔═╗▒▒▒▒▒▒▒▒╔═══╗▒╔╗▒▒▒▒▒▒▒▒')
        print('▒║╔═╗║╔═╗║║▒║║▒║║║╔╝▒▒▒▒▒▒▒▒║╔═╗║▒║║▒▒▒▒▒▒▒▒')
        print('▒║╚══╣╚══╣╚═╝║▒║╚╝╝╔══╦╗▒╔╗▒║║▒║╠═╝╠╗╔╦╦═╗▒▒')
        print('▒╚══╗╠══╗║╔═╗║▒║╔╗║║║═╣║▒║║▒║╚═╝║╔╗║╚╝╠╣╔╗╗▒')
        print('▒║╚═╝║╚═╝║║▒║║▒║║║╚╣║═╣╚═╝║▒║╔═╗║╚╝║║║║║║║║▒')
        print('▒╚═══╩═══╩╝▒╚╝▒╚╝╚═╩══╩═╗╔╝▒╚╝▒╚╩══╩╩╩╩╩╝╚╝▒')
        print('▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╔═╝║▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒')
        print('▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╚══╝▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒')
        print('▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒')
        print('\n Bienvenido al administrador de claves SSH.\n')

    def goodbye(self) -> None:
        """Despedida al usuario."""
        print("              _")
        print("             | |")
        print("             | |===( )   /////")
        print("             |_|   |||  | o o|")
        print("                    ||| ( c  )                 ____")
        print("                     ||| \= /                 ||   \_")
        print("                      ||||||                  ||     |")
        print('                      ||||||               ...||__/|-"')
        print("                      ||||||            __|________|__")
        print("                        |||            |______________|")
        print("                        |||            || ||      || ||")
        print("                        |||            || ||      || ||")
        print("------------------------|||----------- || || ---- || || ------")
        print("                        |__>           ||         ||")

        print("\n¡Hasta luego, que disfrute su día!\n")
        exit(0)  # Salir del programa

    
        """Muestra un arte ASCII de Goligord."""
        print(r":::::::::::;::::::;::::;:;;;;;;;;;;;;;;;;;;t;ttttttt%tttt;%%t%%%%%%%%SSS%SS%SS%SSSSSXSXXXXXXX@8%X8%8")
        print(r":::::::::::::::;::::;:::;;;;:;:;;;;;;t;;;;ttt;;:%%SSS8S:;%8Sttt%%tt%%%%%%%%%S%%SSSSSSSSXXXXXXSX8%X8S")
        print(r".:.:.:::::::::::;::::::;::;;;:;;;;;;;t;;;S8Xt @8:@:  tSX888:@@t::;8X%%S%S%%SXSSSSSSXSXXSXXXX8S8t8%X8")
        print(r"::::::::::::::::::;::::::;;:;;;;;;;;S8.S.%X@XX8X8SX88@88@88888XXX8 88XXXSSS%XSSSSSSSSSXSSXXSSSX8t8SX")
        print(r"::...:.:.:.:::::::::;::;:;;::;:;;;;;@ttStS@X88@8888888888@S@XX@@88S8.S888@8888SSSS%%SSSXSSXS8%8t8%8S")
        print(r".:..:.:.::::::::::::::::::::;;:t;88@%.t%@8@X88X8S8SSS%8S8@XS8@X888@8X8@S8.8@8888@SSSSSXXSXSS%SS8t8t8")
        print(r".:.:::.:.:.:.::::::::::::::::;S;8%%S%X88t8X%%S%%X%XXS@%@%@XX%X%@8SXXt@%@S888XXS%SXSSSSSSSS8t8%SSSS8%")
        print(r".:....:.:.:.:..:.::::::::::;S;8%;%8XX8X@8@%%XS;ttttS888X@X%@@X@t%X%%S;@%@%X8X;XXSSXXSSSXX%S%%8S8S8t8")
        print(r"..:..:.:.:.:.::.:.:::::::::8.XX@88X8@@888%@SX%@XXXX@SSSXSSX%S@tSttXtt%tS%XSSSX88SSSSS%SXSSS8;%SSSS8t")
        print(r"....:.:..:..:..:.:.:.:::;t S@S8XXX8@8888X88888@@@@8888@X8SXt%tSX;%%S@tXt%@;XtX88%@XSSXSSXS%%8t8%8%S8")
        print(r".......:.:.:.:.:.:.:.:::88 .8@S88@8@88@S%X8888888@X88888X@8XXSXtXt%%%t%SS;t%%SX8@.S%%S%%SS8;t8tXS8%X")
        print(r"........:....:.:.:.:.:.%88SXX@8888S;% 8;88t8X8SXSX88888@X@88@@8S@%XS%Xt%tXtStXt@SX:%SSSSS%t8:%8%SX8S")
        print(r"...........:..:.:.:.:.t8.:tX8S88;X@%% @XXX@88S88X88;8t8X88@@8888X@@XSXtX;tXtt%StXt8S%%%%SStt8t%8%SS8")
        print(r". .................:.; 8%X88@8%8S :8     SSX8S@X8888S8888%888X8@8888X@8X%St%@tX%XtX8@%%%%%8;%8tS8S8%")
        print(r".. .. ...........:..:t8@8St88@8.888 88%8SXX8XX@@88888888@8%88888@8888888XXXttSX%XS%X88;SS%;8;%8;SSSX")
        print(r". .. ..............::X;@8S88t8:8888888  88XX@X888888S@8.8;8:888X8S8X8@888XSXtXtXtt@XSSSS%%tt8;%8t8%8")
        print(r".. ... . ...........88%@8SX;S88888888888tXX@X@8888888888X8:8t8@88888S888888XXtS;StSt%S.8%%St;8;%S%SS")
        print(r". .. .... .. .......:tt8%X;888888888%888 SX8@88@@88888888X88.888@8@88S888X88XX;tXt%@tt.8%%%SttSSS8%X")
        print(r".. .. . .. ........S8 :;SS::8888888888888SX@X@88@@8888888%888:88S8@888X888@8@SSS;X%StX@8%%t%%%%S%t%t")
        print(r". ...... .. . . .: Xt .S8S 8888888888 8 8%X88888888@8 88 888:8888@8@8888XX88@@t;%Xt%S;%8.;tttt;t%SX%")
        print(r" .. . ... ........;S.8%X8: 88888X888%88888S@@8X88888%88:8.t888888@@8@888SSX88SS;tXt%%%%X@;t;;;;tX8SX")
        print(r". .... ... . . ...S8 .%@8 8888S88X8@S 8X.X@X8888888888;t88S8;8S@X8X@888X8S888X;%t%@ttS@t:@t;:;;:%S@@")
        print(r".    .. ..... ... S8..S88 8SX888:t8888S88X88888888t8 :8%8X8X8@8X@8@88X@88888@;%%SS;tX;%S:@;:;;:.tSX@")
        print(r" .... .. . ... .. S8;:X888 S88:88S8888@88XX888888X t8%@8888888888888888@88S8@StX;t%%tX;%@t;:::: :%S@")
        print(r" .  .. .... . .. .:@:.X88S  SSX88;8XX88@88X%88.88.Xt8888@@tX@t@X%S%XtXX8@X@@X@%tX;t%ttXt@::::.. .;SX")
        print(r"::;:;::. . ... ....:t:S8888  888.88888@@8%888@  888888888X8X88@8@X888@8X8SSS88%ttSt%XtSX8.::::.. .;S")
        print(r".. . :;t;... . . ..t.;X88 88S88@8%S%X%S@88t8@ 88X88%8888888@8@%%X88S888S8@888XX%%%X;%t@t@ ::.::  :tt")
        print(r". ... ..t%. . .....X8:X@8;88@@8@8@.@tX@S8X@%8S88 88@@88888@88888@888X@X8SSX88X@;%%tSX%X%X.:.::.:St:;")
        print(r":;:.:.::t%: ........: ;X@888X8;8   tX8%@88X88S88 88888@8@8SXtSSX%;tt;%888@88@88X%%X%tXt8t.:::: 8 : S")
        print(r" . .::;:. . ..... . 88%%;8888 88  S888@@8@@S8 888S888X88@8@888888888Xt%@88@S8@@8:ttSSt%;S.:;..t 8  ;")
        print(r". .. . .  ... . ....;X;8;X888888S@88888888%8S 88S8S;8S8X8888@88@@8X888X888@88@88:ttt@@%.t..:::SS   :")
        print(r" . .. .... .. . . .. t;8.@@888888SS88t8tS8@ 88888888X8@8@888@88@8X888X8X8XX888%X@:XX@X88St:::8     .")
        print(r" ...... . .. . ...... ; @88888888 S%X@888% 8888SS88888X88888X8X8888888888888@@%t8%t@88@ 8@:;% t.    ")
        print(r" . . . . . .. . ....@X  @@8888@888%@@8X % 88888888@ 8888S8X@t888@88888888X88@XS8%8X@88@S@%;:SX . .  ")
        print(r". ... . ..... . ...   X88888888888SX  8S8 @@@88@8@88X8@88888@@888@888X88888888888XS8SX;t;t:@t..    .")
        print(r"... . .. . .. ...::.8;%@8S88@88@ 88 88 88@8888888.888@88XX888X@888@888S888888;88.t@888X.;:%.%   .   ")
        print(r". ....  .  . .....::8 8X8888888888S 888S88888@ 8@8X;8X888888S88@8X8S8S@8888@S8S888@X88t ;;t@ .    . ")
        print(r" .. . .. .. . . ....8 8tSXt8SX@8888@ 888S 8@888X888@ 8:8@8@8888888888X888@888%88::8@88S.;Xt.   .    ")
        print(r" ... .  ..........::88@  @SSS88888888@8888888888XSt.8tX@8XX88888888X8888S88X8@.t8X888S8;X;% .    .  ")
        print(r". . . ... ... ......888S:@8SXX88888S88@8X 888888888:@888@888XX@88888@8888;8@8@8::.@88%8;%@ .  .    .")
        print(r".. .... ...........;8 88.%88S88X@888 8S8 8 @.X@@.X888ttt%888X88X88888t8;S8;8X8@8t8%8%%88:% .    .  .")
        print(r".............. ....@8@@%.t%888%8X8888X8X8X%@@8@XS%8@SStt@888XSX8S8888X%8%88%8%X88;888@Xt.S  .     . ")
        print(r":.:................88888%tX%;88S88888X %X 8S8;8  @S888888888888888@888X88888t8;tt;8%8.8 %8 .  . . . ")
        print(r":::::.::..:...... .8888%%.;;%t%X@8888 8888 %@    8S t888888888X8@8X8888888SS8.888 8@88 S%S        . ")
        print(r"::.:.:.....::... .:;8X;8S.:.;%8@88888888888S     S;888@888@@X88XXS8S888@@X%8;%8:SS;88.  XX. .  .  . ")
        print(r".... . ...  ....  ..:..SX...t8S888888888888 8 8S tXS@ tS@8@S@8X@88X88888@S888;t8% SX8 88SS:      .. ")
        print(r". . ...  ... . .  . .. t@;:.:%88888888 88.8SS%@S8888%S888@888888X888X88X8@S@8S888%t8X@88:S: . .   . ")
        print(r".... .... ..... . .  . ;8::;%S8888888@888%8S88 S%8@@S88SSS@X8888SX8@@8X88888888@.8X 8 @t:t;    .  . ")
        print(r". ... . ..  . .   . . ..8t:S8888888888  88%88X8888@8@X8@@8888X8XSX8X888S888XSS88S;@: 8S;.t;.      . ")
        print(r".. .. .. .. . . . . . . XS;XX@88888888888888.88t8888X@8@S8ttX@888888@8@@X@8@8X8@; %@88;:.;t . .  .. ")
        print(r". .  .  . . . . . . . ..tXt%88888888 888  8X8S88888888@@88@8888@88@88@X888X8S8Xt8:tS8@:..:%     . . ")
        print(r" .    . .  . .     . .  :@X8X88S % 8@88@8S88888@@X8S%..%X888XXS@888@8S88888X8S8 ;.;%8S.. .%  .    . ")
        print(r"   .     .    .  .  .  ..@@X@8@8X8@ 8 88;X%@X@t 88XS88S88S888888S888X888S8@XX8X8..:t@X....t.   .  . ")
        print(r" .   . .   .   .   .  .. S88888888@888 XX.S8%;S   88888X8XX888888@8X@@@S8S8S@XS  .:tXX... t: .    . ")
        print(r"         .   .   .     . S888 8888X 888  888888X88@@X8SS8@X888X@@8@88S888X8888@8 ::;X@... t:    . . ")
        print(r"  . .  .   .  .. . ... . %8X8S8X888X8888@888888SS88X8888@@X888888@88X8X@888@X8X8SX;:%@... t; .    ..")
        print(r" .   .   .  ..%8@@@@@t:8@ 8 SS@t8% S%8:8@XS:8t%@888X888888@8888S8X8X8@@@8@@8888%@8.8@8S;88:t. . . %@")
        print(r"  . tt.:. .@tX.X8@8@8S. ;8 88  X8@ SXSX     8@.8S8888888888X@8@88@X8888X88X88XXX;8X;t@@X@:. ;@:X88@8")
        print(r"%8@@;;.     S 8XS.:X@S:;8X%8 SSS@X @SX8XSSX88@8t8XS8@888X88@888S@88S8X@8888@888%Xt@ttt@X%SS8@88S@t8@")
        print(r"X X@8@:;XS% %@%@8 .@8@.@8@888XS@XS 8S  88   X8X.XX888S888@@8X8S8@88X88X8X8X888S%X%St%%%X;SttS8%8tS@8")
        print(r" 8%888@@X@S :8XX@ :@8X:S8XXXX XS8@  888S S SS888 8@88888@888X88888%88S8S@X8@888Xt%%SXt%X;;tt%XXt%S%8")
        print(r"8%88888888;.8tSSX .@8.tt8 @8S XSX@S  88  S X@8@X8X888888X8@888S8@X88X8X@8888888:@tX%;tSt%%%%ttXtt%@8")
        print(r"%8@8888@88;%%8%@8:t8S.8S X8SX  @S SS % X@8 @@8888888SSX88@@888X@888@8X888X8888;;%St@;ttX%SttttSXtt%8")
        print(r"%@8X888@@X%8SS@S8tS8;tt@ %8.8X8SXSX8X S8@8S88.8S8@X888X8@888S@@8X88X888@88@S8X%t%tS%t;t%%%tt%tt%SStX")
        print(r"%X@88X888X88S%XX8tSS.@t;..%%S8 8 @@X @8X8:88@8S@8@8XXSS8@@@888X8@8S88@X8SXS8SX%%%Xt@;tt%XS;tt%St%;t;")
        print(r"tX%@8@88@SX%St@XXt;:;%Xt;..8%;X 8  @@SS@88;8S%@8X888SX888@8@8@@@88@8@88X8888X%tS%t%tt%tXt;tttt;SX;tS")
        print(r"t8@X%@S@@8SXtXtX@S..@t@;t: t.88 888 S@@8@X:8888888888@X8X88@88X8888XX8@X88@8XtSS;t%%t;;t%%S;;tt%S;;t")
        print(r"tX@S8@8888%%S@%XXS :8;Stt%:t8XX8 8X S 888888::@888888X@8X88X88888X@88S8S888@Sttt%%S;t;tStS:ttt%tt%tt")
        print(r"tXS8%8888%St@t@t8S.%S;t%@St%%8X88% 8@88X8@t88.%888@88@@@8888S8X888S@S8888@@%ttt%S%t;%;;ttttt%;;%S@t;")
        print(r"tXX8@888%XtX;%%8XS;8t;;@tXtSX@8S@8 SS@8@XSS@888S88888X@888S8888S8:@S@888@S%%%%%%%%ttt%tS;tt%ttt%tt%t")
        print(r"t@%X88@@Xt%t@S@S8%t8;t;8tXXXX@@8S888 8@8@X88@8888%8@888888X888S88SX8888@@S%%%t%%%%%%;t;t%t%t%t%tStSt")
        print(r"tX@@888StXt%%X@@8t8tt%;%:S888@S%X8X88X8XX@XX@8X888;88888S8t88888888@X8XSS%%%SStt%t%t;tt%%%%tt%%;tSt%")
        print(r";S@888tXtt%@XS888t8%ttt%;X88XXX@SX8@8Xt8@XXXX8888888:8888X8888@88@8@8S%SSXtS;;ttSttttt%%S;%%ttttS;XX")
        print(r"tX888@t%XtXt%8X@@t8t%tS;%XX@8XX@@@@@88@8%8888@X@888888@8X888S88X8@8%@@%%%ttttt%tt%;ttt%%tt%ttttttXtt")
        print(r"%888XStt%StXt@X8SX@%%tt;XS8@X@X@8@XX@X8888888X8888888:888888888888X8@;%Xttt%%ttSttttt%S;t%%S;tt%%%@%")
        print(r"S8@XX;S%StSXSX@8S8Xtt%t;8t@88@8X@X88888@888S88t8888 8%888@X88888888%tSttS;ttt%t%%tttttt%%%%ttt%SXSSS")
        print(r"@8@@;S;%XtX@S888S8%S%t%%8t@88@@X8@S8@888@@@88@88SX%88X@8@@88X8@8@8t%St%%tttttt%S;t;ttSXt%%t%%SS;%XXS")
        print(r"8XXt%tXt%XSX8@88t8X;%%S;%;S8@S88@@@X88X@8888888SSSSS888X8@8@8XX%ttX;t%t%ttttt%S;;;%tS;t%t%X;%ttS@@Xt")
        print(r"@@ttXttXtX%8888@S8t%%ttttXS8@@S8@88888888888888888888@8888XX:t@@SX;%%S;ttt%t%St%%;t;t%@tttt%StStS8@@")
        print(r"StS%%X%XSSXS8@@SS@t%%tt%t8S8@X%S88@8888888X888888888@888888X8XtS%ttS;;tt;tt%X%St%t;tXS;tStSt%S@%88X%")
        print(r"t%%%S%XtS@S@@@8XX@ttt%%%ttSS88@S;@88@888888@888888888@8@@88@%@ttSt%;;;tttt%%Xt%tttt;S%X;;ttXS%SXX8@X")

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
                key_file_name = self.names_gen()
                break
        return key_file_name

    def names_gen(self) -> str:
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
        print("\nADVERTENCIA: Si se establece una frase de contraseña, deberás ingresarla cada vez que uses la clave SSH.")
        print("En caso de olvidarla, deberás generar una nueva clave SSH.")
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
    
    def is_number(self, s: str) -> bool:
        """
        Verifica si la cadena proporcionada es un número entero.
        
        Args:
            s (str): Cadena a verificar.
        
        Returns:
            bool: True si es un número entero, False en caso contrario.
        """
        try:
            int(s)
            return True
        except ValueError:
            return False
     
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
        
        def csv_load(nombre_archivo: str) -> list:
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
                data = csv_load(CSV)
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
                            key_name = self.names_gen()
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
         
    def file_search(self,list_keys: list) -> str | None:
        key_name = input("\nIntroduce el nombre de la clave SSH (sin extensión) o su número de orden: \n").strip()
        if self.is_number(key_name):
            numered_keys = enumerate(list_keys, start=1)
            # Pasamos a buscar la clave pública por su número de orden
            for index, key in numered_keys:
                if index == int(key_name):
                    key_name = key.split('.pub')[0]
                    break
        elif not self.input_char_validate(key_name):
            print("El nombre de la clave solo puede contener letras, números, guiones bajos y guiones.")
            return None
        return key_name
    
    def show_key(self) -> None:
        """
        Muestra el contenido de la clave pública SSH por pantalla.
        """
        list_keys = self.show_keys()  # Llama al método para mostrar las claves SSH
        while True:
            key_name = self.file_search(list_keys) # Solicitamos el nombre o número de la clave SSH desde las claves existentes en .ssh
            if key_name and key_name+".pub" in list_keys:
                public_key = self.display_public_key(key_name) # Se entrega el contenido de la clave pública
                if public_key:
                    self.copy_to_clipboard(public_key)
                else:
                    print(f"No se pudo mostrar la clave pública para {key_name}. Asegúrate de que la clave exista.")
                break
            else:
                print(f"La clave {key_name} no se encontró en la lista de claves SSH. Por favor, verifica el nombre o número de orden.")
                continue
        return None
    
    def ssh_edit_menu(self) -> None:
        """
        Implementación de menú para editar claves SSH existentes.
        """
        print("\n--- Menú de edición de claves SSH ---")
        print("1. Mostrar clave pública SSH")
        print("2. Cambiar nombre de claves SSH")
        print("3. Eliminar clave SSH")
        print("4. Volver al menú principal")
        
        while True:
            opción = input("Selecciona una opción: ").strip()
            if not re.match(r"^\d+$", opción):
                print("Por favor, ingresa un número válido para la opción.")
                continue
            break

        def edit_key() -> None:
            """
            Edita el nombre de una clave SSH existente.
            """
            list_keys = self.show_keys()  # Llama al método para mostrar las claves SSH
            while True:
                key_name = self.file_search(list_keys) # Solicitamos el nombre o número de la clave SSH desde las claves existentes en .ssh
                if key_name and key_name+".pub" in list_keys:
                    while True:
                        new_key_name = input("\nIntroduce el nuevo nombre para la clave SSH (sin extensión): \n").strip()
                        print("")
                        if not self.input_char_validate(new_key_name):
                            print("El nombre de la clave solo puede contener letras, números, guiones bajos y guiones.")
                            continue
                        break
                    new_key_path = os.path.join(self.ssh_dir, new_key_name)
                    if os.path.exists(new_key_path):
                        print(f"El archivo {new_key_path} ya existe. \n")
                        continue
                    old_key_path = os.path.join(self.ssh_dir, key_name)
                    old_pub_key_path = old_key_path + ".pub"
                    new_pub_key_path = new_key_path + ".pub"
                    os.rename(old_key_path, new_key_path)
                    os.rename(old_pub_key_path, new_pub_key_path)
                    print(f"Clave SSH renombrada de {key_name} a {new_key_name} exitosamente.")
                    break
                else:
                    print(f"La clave {key_name} no se encontró en la lista de claves SSH. Por favor, verifica el nombre o número de orden.")
                    continue
            return None
         
        def remove_key() -> None:
            """
            Elimina una clave SSH existente elegida desde una lista impresa en pantalla.
            """
            list_keys = self.show_keys()  # Llama al método para mostrar las claves SSH
            while True:
                key_name = self.file_search(list_keys) # Solicitamos el nombre o número de la clave SSH desde las claves existentes en .ssh
                if key_name and key_name+".pub" in list_keys:
                    key_path = os.path.join(self.ssh_dir, key_name)
                    pub_key_path = key_path + ".pub"
                    os.remove(key_path)
                    os.remove(pub_key_path)
                    print(f"La clave SSH {key_name} y su clave pública han sido eliminadas exitosamente.")
                    break
                else:
                    print(f"La clave {key_name} no se encontró en la lista de claves SSH. Por favor, verifica el nombre o número de orden.")
                    continue
            return None
        
        # --- Menú de opciones ---
        match int(opción):
            case 1:
                self.show_key()
            case 2:
                edit_key()
            case 3:
                remove_key()
            case 4:
                return None
            case _:
                print("\nSeleccione una opción correcta basada en el número indicado a su izquierda.")
                return None

    # --------- Bloque Agente SSH ---------

    def check_ssh_agent_running(self):
        """
        Verifica si el agente SSH está corriendo.
        Retorna True si está corriendo, False en caso contrario.
        """
        if os.name == "nt":
            try:
                # En Windows, comprobamos el servicio OpenSSH Authentication Agent con PowerShell.
                result = subprocess.run(
                    ["powershell", "-Command", "Get-Service ssh-agent | Select-Object -ExpandProperty Status"],
                    capture_output=True, text=True, check=True
                )
                return "Running" in result.stdout.strip()
            except (subprocess.CalledProcessError, FileNotFoundError):
                return False
        elif os.name == "posix": # Linux, macOS, etc.
            # En sistemas Unix-like, comprobamos la variable SSH_AUTH_SOCK y si ssh-add puede listar las claves.
            if "SSH_AUTH_SOCK" in os.environ:
                try:
                    result = subprocess.run(
                        ["ssh-add", "-l"],
                        capture_output=True, text=True, check=False # check=False porque ssh-add -l puede fallar si no hay claves
                    )
                    # Si ssh-add -l devuelve un código de salida 0, el agente está accesible.
                    # También verificamos si la salida no indica un error de conexión al agente.
                    return result.returncode == 0 and "Could not open a connection to your authentication agent" not in result.stderr
                except FileNotFoundError:
                    return False
            return False
        else:
            raise EnvironmentError("Sistema operativo no soportado. Este script solo funciona en Windows, Linux y macOS. "
                                f"Sistema detectado: {os.name}")
    
    def start_ssh_agent(self):
        """
        Intenta iniciar el agente SSH de forma multiplataforma.
        Retorna True si se inició o si ya estaba corriendo, False en caso de error.
        """
        if self.check_ssh_agent_running():
            print("El agente SSH ya está corriendo.")
            return True

        print("Intentando iniciar el agente SSH...")
        if os.name == "nt":
            try:
                # En Windows, iniciar el servicio "OpenSSH Authentication Agent"
                # Necesita permisos de administrador para esto.
                # Idealmente, el usuario ya debería haber configurado el servicio en automático.
                print("En Windows, asegúrate de que el servicio 'OpenSSH Authentication Agent' esté configurado como 'Automático' o 'Automático (Inicio retrasado)' y esté iniciado.")
                print("Puedes intentar iniciarlo manualmente con PowerShell (como administrador):")
                print("  Set-Service ssh-agent -StartupType Automatic -PassThru | Start-Service")
                # Este script por sí mismo no puede elevar permisos para iniciar el servicio.
                # Por lo tanto, el usuario debe haberlo configurado o iniciarlo manualmente.
                # Si el servicio no está corriendo y no se puede iniciar, `ssh-add` fallará.
                return True # Asumimos que el usuario lo manejará o ya está iniciado
            except Exception as e:
                print(f"Error al intentar iniciar el agente SSH en Windows (requiere privilegios): {e}")
                return False
        else: # Linux y macOS
            try:
                # En sistemas Unix-like, usamos 'eval $(ssh-agent -s)' para configurar el entorno.
                # Es crucial capturar la salida para establecer las variables de entorno.
                result = subprocess.run(
                    ["ssh-agent", "-s"],
                    capture_output=True, text=True, check=True
                )
                # Parsear la salida para obtener las variables de entorno (SSH_AUTH_SOCK, SSH_AGENT_PID)
                # y establecerlas en el entorno del proceso Python.
                for line in result.stdout.splitlines():
                    if line.startswith("SSH_AUTH_SOCK="):
                        os.environ["SSH_AUTH_SOCK"] = line.split("=")[1].split(";")[0]
                    elif line.startswith("SSH_AGENT_PID="):
                        os.environ["SSH_AGENT_PID"] = line.split("=")[1].split(";")[0]
                print("Agente SSH iniciado y variables de entorno configuradas.")
                return True
            except subprocess.CalledProcessError as e:
                print(f"Error al iniciar el agente SSH: {e}")
                print(f"Stderr: {e.stderr}")
                return False
            except FileNotFoundError:
                print("Comando 'ssh-agent' no encontrado. Asegúrate de tener OpenSSH instalado.")
                return False
    
    def add_ssh_key(self):
        """
        Añade una clave SSH al agente sleccionada de forma manual desde una lista de claves SSH actuales.
        Retorna True si la clave se añadió correctamente, False en caso contrario.
        """
        if not self.check_ssh_agent_running():
            print("\nEl agente SSH no está corriendo. No se puede añadir la clave.\n")
            return False

        list_keys = self.show_keys()  # Llama al método para mostrar las claves SSH
        if not list_keys:
            print("No hay claves SSH disponibles para añadir al agente. \nPor favor, genera una clave SSH primero desde la opción 2 del menú principal.\n")
            return False     
        
        while True:
            key_name = self.file_search(list_keys) # Solicitamos el nombre o número de la clave SSH desde las claves existentes en .ssh
            if key_name and key_name+".pub" in list_keys:
                key_path = os.path.join(self.ssh_dir, key_name)
                print(f"Intentando añadir la clave: {key_path}\n")
                command = ["ssh-add", key_path]
                passphrase = input("Si la clave tiene una passphrase, introdúcela ahora (dejar en blanco si no tiene): ").strip()
                if passphrase:
                    # Si hay una passphrase, la pasamos a stdin.
                    # Esto es un poco más delicado y puede variar en comportamiento.
                    # Idealmente, el usuario debería haberla introducido manualmente o usar un gestor de claves.
                    try:
                        result = subprocess.run(
                            command,
                            input=passphrase + "\n", # Añadimos un salto de línea
                            capture_output=True, text=True, check=True, encoding='utf-8'
                        )
                        print(f"Salida de ssh-add: {result.stdout}")
                        if result.stderr:
                            print(f"Errores de ssh-add: {result.stderr}")
                        return "Identity added" in result.stdout
                    except subprocess.CalledProcessError as e:
                        print(f"Error al añadir la clave (con passphrase): {e}")
                        print(f"Stderr: {e.stderr}")
                        return False
                else:
                    try:
                        result = subprocess.run(
                            command,
                            capture_output=True, text=True, check=True
                        )
                        print(f"Salida de ssh-add: {result.stdout}")
                        if result.stderr:
                            print(f"Errores de ssh-add: {result.stderr}")
                        return "Identity added" in result.stdout
                    except subprocess.CalledProcessError as e:
                        print(f"Error al añadir la clave: {e}")
                        print(f"Stderr: {e.stderr}")
                        # Mensajes comunes de error: "Agent admitted failure to sign using the key."
                        # "Could not open a connection to your authentication agent."
                        # "Error loading key: agent refused operation"
                        if "agent refused operation" in e.stderr:
                            print("El agente SSH rechazó la operación. Esto puede ocurrir si la clave ya está añadida o si hay un problema con la passphrase.")
                        return False
                    except FileNotFoundError:
                        print("Comando 'ssh-add' no encontrado. Asegúrate de tener OpenSSH instalado y operando normalmente.")
                        return False
    # --------------------------------------
    
    @staticmethod
    def open_link_web(url):
        """
        Abre una URL en el navegador web predeterminado del sistema.
        """
        
        import webbrowser
        
        try:
            webbrowser.open(url)
            print(f"Abriendo el vínculo: {url}")
        except Exception as e:
            print(f"No se pudo abrir el vínculo: {url}. Error: {e}")
    
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
    
    ka.greetings() # Saludo inicial al usuario
    
    while True:
        print("--- Por favor, elija la opción deseada:\n")
        print("1. Mostrar lista de claves SSH")
        print("2. Generar nueva clave SSH")
        print("3. Generar múltiples claves SSH desde CSV. (Ver documentación, opción 6)")
        print("4. Operar sobre clave existente: Editar nombre, eliminar clave, mostrar clave pub, etc.")
        print("5. Añadir clave(s) al agente SSH") # TODO: Implementar más adelante.
        print("6. Documentación y ayuda: github.com/CristianFK-Dev/scripts/blob/main/Windows/Docs/000_ssh_keys.md")
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
                ka.ssh_edit_menu()
            case 5:
                print("\n---------------------------------------------")
                ka.start_ssh_agent() # Inicia el agente SSH si no está corriendo
                ka.add_ssh_key()  # Llama al método para añadir una clave SSH al agente
            case 6:
                ka.open_link_web("https://github.com/CristianFK-Dev/scripts/blob/main/Windows/Docs/000_ssh_keys.md")
            case 7:
                return ka.goodbye()  # Llama al método de despedida
            case _:
                print("\nSeleccione una opción correcta basada en el número indicado a su izquierda.")


if __name__ == "__main__":
    
    ka = key_admin() # Crear instancia de la clase key_admin 
    
    status = main_menu(ka)