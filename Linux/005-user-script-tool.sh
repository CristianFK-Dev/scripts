#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo -e "\n🔒 Este script debe ejecutarse como root (usá sudo)\n"
    exit 1
fi

cs() {
    if [ -t 1 ]; then
        clear
    fi
}

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"
RESET="\e[0m"

generate_data() {
    local filter_type="$1"
    local user_source

    # Definir el comando awk para filtrar usuarios según la elección
    case "$filter_type" in
        "system")
            user_source=$(awk -F: '$3 < 1000 && $1 != "nobody" {print $1, $3, $6, $7}' /etc/passwd)
            ;;
        "normal")
            user_source=$(awk -F: '$3 >= 1000 {print $1, $3, $6, $7}' /etc/passwd)
            ;;
        *)
            user_source=$(awk -F: '$1 != "nobody" {print $1, $3, $6, $7}' /etc/passwd)
            ;;
    esac

    # Procesa la lista de usuarios filtrada para generar los datos con una clave de ordenamiento.
    # Clave 1 (sort_key_shell): 0 para shell activo, 1 para inactivo.
    # Clave 2 (login_timestamp): Timestamp de Unix del último login (0 si nunca).
    # Esto ordena: 1. Por estado del shell, 2. Por fecha de login descendente.
    # Formato de salida: sort_key_shell|login_timestamp|USUARIO (UID)|HOME|...
    echo "$user_source" | while read -r user uid home_dir shell; do
        local sort_key_shell
        local login_timestamp
        local shell_status
        local password_status
        local account_lock_status
        local account_expiry_status
        local expiry_status
        local last_change_status
        local min_max_days
        local last_login_status

        # Verificar tipo de shell
        if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
            sort_key_shell=1 # Shell inactivo
            login_timestamp=0
            shell_status="🔴NO SHELL"
            password_status="N/A"
            account_lock_status="N/A"
            account_expiry_status="N/A"
            expiry_status="N/A"
            last_change_status="N/A"
            min_max_days="N/A"
            last_login_status="N/A"
        else
            sort_key_shell=0 # Shell activo
            shell_status="🟢SHELL: $shell"
            # Verificar estado de contraseña (usando passwd -S)
            password_info=$(passwd -S "$user" 2>/dev/null)
            if [ -z "$password_info" ]; then
                password_status="❓NO EXISTE"
                account_lock_status="N/A"
                account_expiry_status="N/A"
                expiry_status="N/A"
                last_change_status="N/A"
                min_max_days="N/A"
                last_login_status="N/A"
            else
                # Extraer estado de la contraseña (L=bloqueada, P=activa, NP=sin contraseña) 
                password_state=$(echo "$password_info" | awk '{print $2}')  
                case "$password_state" in
                    "L") password_status="🔴BLOCK";;
                    "P") password_status="🟢ACTIVE";;
                    "NP") password_status="🔓NO PASS";;
                    *) password_status="❓ $password_state";;
                esac

                # Obtener y formatear datos de políticas de contraseña con chage
                chage_info=$(chage -l "$user" 2>/dev/null)

                # Verificar estado de la cuenta (bloqueada por expiración)
                account_expiry_date=$(echo "$chage_info" | awk -F: '/^Account expires/ {print $2}' | xargs)
                if [[ -z "$account_expiry_date" || "$account_expiry_date" == "never" ]]; then
                    account_lock_status="✅UNLOCK"
                else
                    # Comparamos fechas en formato YYYY-MM-DD para evitar problemas de locale
                    account_expiry_yyyymmdd=$(date -d "$account_expiry_date" "+%Y-%m-%d" 2>/dev/null)
                    current_yyyymmdd=$(date "+%Y-%m-%d")
                    if [[ -n "$account_expiry_yyyymmdd" && "$account_expiry_yyyymmdd" < "$current_yyyymmdd" ]]; then
                        account_lock_status="❌BLOCK"
                    else
                        account_lock_status="✅UNLOCK"
                    fi
                fi

                # La columna VENCE muestra la expiración de la CONTRASEÑA.
                expiry_date=$(echo "$chage_info" | awk -F: '/^Password expires/ {print $2}' | xargs)
                if [[ -z "$expiry_date" || "$expiry_date" == "never" ]]; then
                    expiry_status="Nunca"
                else
                    expiry_status=$(date -d "$expiry_date" "+%d/%m/%Y" 2>/dev/null || echo "$expiry_date")
                fi

                last_change=$(echo "$chage_info" | awk -F: '/^Last password change/ {print $2}' | xargs)
                if [[ -z "$last_change" || "$last_change" == "never" ]]; then
                    last_change_status="Nunca"
                else
                    last_change_status=$(date -d "$last_change" "+%d/%m/%Y" 2>/dev/null || echo "$last_change")
                fi

                min_days=$(echo "$chage_info" | awk -F: '/^Minimum number of days/ {print $2}' | xargs)
                max_days=$(echo "$chage_info" | awk -F: '/^Maximum number of days/ {print $2}' | xargs)
                min_max_days="${min_days:-?}/${max_days:-?}"

                # Obtener último login interactivo
                last_login_info=$(LC_ALL=C lastlog -u "$user" 2>/dev/null | tail -n 1)
                if echo "$last_login_info" | grep -q -F '**Never logged in**'; then
                    login_timestamp=0
                    last_login_status="Nunca"
                else
                    # Extraer la fecha de forma robusta, buscando el día de la semana (en inglés)
                    # y tomando el resto de la línea. Esto evita problemas con distintos
                    # formatos de salida de `lastlog` o locales.
                    last_login_status=$(echo "$last_login_info" | awk '{
                        for (i=1; i<=NF; i++) {
                            if ($i ~ /^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)$/) {
                                for (j=i; j<=NF; j++) { printf "%s ", $j }
                                print ""
                                exit
                            }
                        }
                    }' | xargs)
                    # Convertir fecha a timestamp. Si falla, es 0.
                    login_timestamp=$(date -d "$last_login_status" +%s 2>/dev/null || echo 0)
                fi
            fi
        fi
        # Imprimir fila con delimitador para que 'column' la procese.
        echo "$sort_key_shell|$login_timestamp|$user ($uid)|$home_dir|$shell_status|$password_status|$account_lock_status|$expiry_status|$last_change_status|$min_max_days|$last_login_status"
    done
}

prompt_for_user() {
    local prompt_text="$1"
    local user_to_manage
    read -rp "$prompt_text" user_to_manage

    if [[ -z "$user_to_manage" ]]; then
        echo -e "\n❌ No se ingresó ningún usuario. Operación cancelada."
        echo "" && return 1
    fi

    if ! id "$user_to_manage" &>/dev/null; then
        echo -e "\n❌ El usuario '\e[1m$user_to_manage\e[0m' no existe. Verificá el nombre."
        echo "" && return 1
    fi

    echo "$user_to_manage"
    return 0
}

show_user_stats() {
    local user
    user=$(prompt_for_user "🔎 Ingrese el nombre del usuario para ver sus estadísticas: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    cs
    echo -e "--- Estadísticas para el usuario: \e[1;33m$user\e[0m ---"
    echo -e "\n\e[1m--- Información de Contraseña (chage) ---\e[0m"
    chage -l "$user"
    echo -e "\n\e[1m--- IDs de Usuario y Grupo (id) ---\e[0m"
    id "$user"
    echo -e "\n\e[1m--- Último Login (lastlog) ---\e[0m"
    lastlog -u "$user"
    echo "-----------------------------------------"
    read -rp "Presioná ENTER para continuar..."
}

lock_password() {
    local user
    user=$(prompt_for_user "🔐 Ingrese el nombre del usuario para BLOQUEAR la CONTRASEÑA: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    echo -e "\nBloqueando la contraseña de '\e[1m$user\e[0m'..."
    if passwd -l "$user" &>/dev/null; then
        echo -e "\n✅ Contraseña de '\e[1m$user\e[0m' bloqueada correctamente."
    else
        echo -e "\n❌ Error al bloquear la contraseña de '\e[1m$user\e[0m'."
    fi
    read -rp "Presioná ENTER para continuar..."
}

unlock_password() {
    local user
    user=$(prompt_for_user "🔓 Ingrese el nombre del usuario para DESBLOQUEAR la CONTRASEÑA: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    echo -e "\nDesbloqueando la contraseña de '\e[1m$user\e[0m'..."
    if passwd -u "$user" &>/dev/null; then
        echo -e "\n✅ Contraseña de '\e[1m$user\e[0m' desbloqueada correctamente."
    else
        echo -e "\n❌ Error al desbloquear la contraseña de '\e[1m$user\e[0m'."
    fi
    read -rp "Presioná ENTER para continuar..."
}

lock_account() {
    local user
    user=$(prompt_for_user "🔐 Ingrese el nombre del usuario para BLOQUEAR la CUENTA COMPLETA: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    if [[ "$user" == "root" ]]; then echo -e "\n❌ No se puede bloquear la cuenta 'root'."; read -rp "..."; return; fi

    echo -e "\nBloqueando la cuenta completa de '\e[1m$user\e[0m' (expirando la cuenta)..."
    # chage -E 0 or usermod -e 1 sets the expiration date to Jan 1, 1970
    if chage -E 0 "$user" &>/dev/null; then
        echo -e "\n✅ Cuenta '\e[1m$user\e[0m' bloqueada correctamente (expirada)."
    else
        echo -e "\n❌ Error al bloquear la cuenta '\e[1m$user\e[0m'."
    fi
    read -rp "Presioná ENTER para continuar..."
}

unlock_account() {
    local user
    user=$(prompt_for_user "🔓 Ingrese el nombre del usuario para DESBLOQUEAR la CUENTA COMPLETA: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    echo -e "\nDesbloqueando la cuenta completa de '\e[1m$user\e[0m' (quitando expiración)..."
    # chage -E -1 or usermod -e "" removes the expiration date
    if chage -E -1 "$user" &>/dev/null; then
        echo -e "\n✅ Cuenta '\e[1m$user\e[0m' desbloqueada correctamente (sin expiración)."
    else
        echo -e "\n❌ Error al desbloquear la cuenta '\e[1m$user\e[0m'."
    fi
    read -rp "Presioná ENTER para continuar..."
}

change_user_password() {
    local user
    user=$(prompt_for_user "🔑 Ingrese el nombre del usuario para cambiar su contraseña: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    echo -e "\nSe iniciará el proceso para cambiar la contraseña de '\e[1m$user\e[0m'..."
    passwd "$user"
    echo -e "\n✅ Proceso finalizado."
    read -rp "Presioná ENTER para continuar..."
}

delete_user() {
    local user
    user=$(prompt_for_user "🗑️  Ingrese el nombre del usuario a BORRAR: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    if [[ "$user" == "root" ]]; then echo -e "\n❌ No se puede borrar al usuario 'root'."; read -rp "..."; return; fi

    echo -e "\n\e[1;31m⚠️ ¡ACCIÓN DESTRUCTIVA! Estás a punto de borrar al usuario '$user'.\e[0m"
    read -rp "🔐 Para confirmar, escribí el nombre de usuario otra vez: " confirmation
    if [[ "$confirmation" != "$user" ]]; then echo -e "\n❌ Confirmación incorrecta. Operación cancelada."; read -rp "..."; return; fi

    local delete_home=""
    read -rp "¿Borrar también el directorio home del usuario (/home/$user)? (s/n): " delete_home_choice
    if [[ "$delete_home_choice" =~ ^[sS]$ ]]; then delete_home="-r"; fi

    echo -e "\nBorrando usuario '$user'..."
    if userdel $delete_home "$user" 2>/dev/null; then echo -e "\n✅ Usuario '$user' borrado."; else echo -e "\n❌ Error al borrar '$user'."; fi
    read -rp "Presioná ENTER para continuar..."
}

create_user() {
    local new_user home_dir shell groups useradd_cmd

    while true; do
        read -rp "Ingrese el nombre del nuevo usuario (solo minúsculas, números, guion, guion bajo): " new_user
        if [[ -z "$new_user" ]]; then
            echo -e "\n❌ El nombre de usuario no puede estar vacío."
            continue
        fi
        if ! [[ "$new_user" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
            echo -e "\n❌ Nombre de usuario no válido. Usá solo minúsculas, números, guiones y guiones bajos."
            continue
        fi
        if id "$new_user" &>/dev/null; then
            echo -e "\n❌ El usuario '\e[1m$new_user\e[0m' ya existe."
            continue
        fi
        break
    done

    read -rp "Directorio home a crear [/home/$new_user]: " home_dir
    home_dir=${home_dir:-/home/$new_user}

    read -rp "Shell de inicio de sesión [/bin/bash]: " shell
    shell=${shell:-/bin/bash}

    read -rp "Grupos adicionales (separados por coma, ej: sudo,docker): " groups

    useradd_cmd="useradd -m -d \"$home_dir\" -s \"$shell\""
    if [[ -n "$groups" ]]; then
        useradd_cmd+=" -G \"$groups\""
    fi
    useradd_cmd+=" \"$new_user\""

    echo -e "\nCreando usuario con el comando: \e[1m$useradd_cmd\e[0m"
    if eval "$useradd_cmd"; then
        echo -e "\n✅ Usuario '\e[1m$new_user\e[0m' creado. Ahora, establecé su contraseña."
        passwd "$new_user"
    else
        echo -e "\n❌ Error al crear el usuario. Revisá los parámetros."
    fi
    read -rp "Presioná ENTER para continuar..."
}

set_password_policy() {
    local user
    user=$(prompt_for_user "📅 Ingrese el usuario para definir la política de vencimiento de CONTRASEÑA: ")
    if [[ -z "$user" ]]; then read -rp "Presioná ENTER para continuar..."; return; fi

    local max_days
    read -rp "Ingrese los días de validez de la contraseña (0 para que no venza nunca): " max_days

    if ! [[ "$max_days" =~ ^[0-9]+$ ]]; then
        echo -e "\n❌ Entrada no válida. Debe ser un número."
        read -rp "Presioná ENTER para continuar..."
        return
    fi

    if [[ "$max_days" -eq 0 ]]; then
        echo -e "\nConfigurando la contraseña de '\e[1m$user\e[0m' para que no expire nunca..."
        if chage -M -1 "$user" &>/dev/null; then
            echo -e "\n✅ Política de contraseña actualizada para '\e[1m$user\e[0m'."
        else
            echo -e "\n❌ Error al actualizar la política de contraseña para '\e[1m$user\e[0m'."
        fi
    else
        echo -e "\nEstableciendo la validez de la contraseña de '\e[1m$user\e[0m' a \e[1m$max_days\e[0m días..."
        if chage -M "$max_days" "$user" &>/dev/null; then
            echo -e "\n✅ Política de contraseña actualizada para '\e[1m$user\e[0m'."
        else
            echo -e "\n❌ Error al actualizar la política de contraseña para '\e[1m$user\e[0m'."
        fi
    fi
    read -rp "Presioná ENTER para continuar..."
}

run_dashboard() {
    local filter="$1"
    while true; do
        cs
        local report_data
        report_data=$(generate_data "$filter")

echo -e "${CYAN}.------------------------------------------------------------------------------------------."
echo -e "${CYAN}|  ${CYAN}_   _ ____  _____ ____    ____   ____ ____  ___ ____ _____   ${CYAN}|-----------${YELLOW}MENU${CYAN}-----------|"
echo -e "${CYAN}| | | | / ___|| ____|  _ \  / ___| / ___|  _ \|_ _|  _ \_   _|  ${CYAN}|  ${YELLOW}1)${RESET}🔎 Ver stats          ${CYAN}|"
echo -e "${CYAN}| | | | \___ \|  _| | |_) | \___ \| |   | |_) || || |_) || |    ${CYAN}|  ${YELLOW}2)${RESET}🔐 Bloquear pass      ${CYAN}|"
echo -e "${CYAN}| | |_| |___) | |___|  _ <   ___) | |___|  _ < | ||  __/ | |    ${CYAN}|  ${YELLOW}3)${RESET}🔓 Desbloquear pass   ${CYAN}|"
echo -e "${CYAN}|  \___/|____/|_____|_| \_\ |____/ \____|_| \_\___|_|    |_|    ${CYAN}|  ${YELLOW}4)${RESET}🔐 Bloquear Cuenta    ${CYAN}|"
echo -e "${CYAN}| |_   _/ _ \ / _ \| |                                          ${CYAN}|  ${YELLOW}5)${RESET}🔓 Desbloquear Cuenta ${CYAN}|"
echo -e "${CYAN}|   | || | | | | | | |                                          ${CYAN}|  ${YELLOW}6)${RESET}📅 Vencimiento pass   ${CYAN}|"
echo -e "${CYAN}|   | || |_| | |_| | |___                                       ${CYAN}|  ${YELLOW}7)${RESET}🔑 Cambiar Pass       ${CYAN}|"
echo -e "${CYAN}|   |_| \___/ \___/|_____|                                      ${CYAN}|  ${YELLOW}8)${RESET}➕ Crear User         ${CYAN}|"
echo -e "${CYAN}|                                                               ${CYAN}|  ${YELLOW}9)${RESET}🗑️  Borrar User        ${CYAN}|"
echo -e "${CYAN}|                                                               ${CYAN}| ${YELLOW}10)${RESET}🔙 Volver             ${CYAN}|"
echo -e "${CYAN}|    ${MAGENTA}#GESTIÓN DE USUARIOS# -by CristianFK-                      ${CYAN}|  ${RED}s)${RESET}🚪 SALIR              ${CYAN}|"
echo -e "${CYAN}'------------------------------------------------------------------------------------------'${RESET}"

        echo  "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"

        if [[ -z "$report_data" ]]; then
            echo -e "\n✅ No se encontraron usuarios para el filtro seleccionado.\n"
        else
            local HEADER="USUARIO (UID)|HOME|SHELL|PASS|CUENTA|VENCE PASS|ÚLTIMO CAMBIO|MIN/MAX|ÚLTIMO LOGIN SSH"
            (
                echo -e "\e[1;33m$HEADER\e[0m"
                echo "$report_data" | sort -t'|' -k1,1n -k2,2nr | cut -d'|' -f3-
            ) | column -t -s '|' -o ' | '
        fi
        echo  "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
      
        read -rp $'\e[38;5;208m   TU ELECCIÓN: \e[0m' mgmt_choice
        echo ""

        case "$mgmt_choice" in
            1) show_user_stats ;;
            2) lock_password ;;
            3) unlock_password ;;
            4) lock_account ;;
            5) unlock_account ;;
            6) set_password_policy ;;
            7) change_user_password ;;
            8) create_user ;;
            9) delete_user ;;
           10) break ;;
            s) cs; echo -e "\n👋 Saliendo.\n"; exit 0 ;;
            *) echo -e "\n❌ Opción no válida. Presioná ENTER para reintentar."; read -r ;;
        esac
    done
}

while true; do
    cs

echo -e "${CYAN}.--------------------------------------------------------------------------------------."
echo -e "${CYAN}|  ${CYAN}_   _ ____  _____ ____    ____   ____ ____  ___ ____ _____   ${CYAN}|                      |"
echo -e "${CYAN}| | | | / ___|| ____|  _ \  / ___| / ___|  _ \|_ _|  _ \_   _|  ${CYAN}|---------${YELLOW}MENU${CYAN}---------|"
echo -e "${CYAN}| | | | \___ \|  _| | |_) | \___ \| |   | |_) || || |_) || |    ${CYAN}|   ${GREEN}AUDITAR USUARIOS${CYAN}   |"
echo -e "${CYAN}| | |_| |___) | |___|  _ <   ___) | |___|  _ < | ||  __/ | |    ${CYAN}|                      |"
echo -e "${CYAN}|  \___/|____/|_____|_| \_\ |____/ \____|_| \_\___|_|    |_|    ${CYAN}|   ${YELLOW}1)${RESET}👥 Todos         ${CYAN}|"
echo -e "${CYAN}| |_   _/ _ \ / _ \| |                                          ${CYAN}|   ${YELLOW}2)${RESET}🤖 Sistema       ${CYAN}|"
echo -e "${CYAN}|   | || | | | | | | |                                          ${CYAN}|   ${YELLOW}3)${RESET}😊 Normales      ${CYAN}|"
echo -e "${CYAN}|   | || |_| | |_| | |___                                       ${CYAN}|   ${RED}s)${RESET}🚪 SALIR         ${CYAN}|"
echo -e "${CYAN}|   |_| \___/ \___/|_____|${MAGENTA}#GESTIÓN DE USUARIOS# -by CristianFK- ${CYAN}|                      |"
echo -e "${CYAN}'--------------------------------------------------------------------------------------'${RESET}"

    read -rp $'\e[38;5;208m   TU ELECCIÓN: \e[0m' choice

    filter=""
    case "$choice" in
        1) filter="all" ;;
        2) filter="system" ;;
        3) filter="normal" ;;
        s) cs; echo -e "\n👋 Saliendo.\n"; exit 0 ;;
        *) echo -e "\n❌ Opción no válida. Inténtalo de nuevo."; sleep 2; continue ;;
    esac

    run_dashboard "$filter"
done