#!/bin/bash
#---------------------------------------------------
# title         : rvsh.sh 
# author        : G. Mahfoudi & S. JUHEL
# version       : 0.1    
# description   : ...
# bash_version  : 4.3.X-release
#---------------------------------------------------



# Reset
NC='\e[0m'       # Text Reset


# Regular Colors
BLACK='\e[0;30m'        # Black
RED='\e[0;31m'          # Red
GREEN='\e[0;32m'        # Green
YELLOW='\e[0;33m'       # Yellow
BLUE='\e[0;34m'         # Blue
PURPLE='\e[0;35m'       # Purple
CYAN='\e[0;36m'         # Cyan
WHITE='\e[0;37m'        # White

# Bold
BBLACK='\e[1;30m'       # Black
BRED='\e[1;31m'         # Red
BGREEN='\e[1;32m'       # Green
BYELLOW='\e[1;33m'      # Yellow
BBLUE='\e[1;34m'        # Blue
BPURPLE='\e[1;35m'      # Purple
BCYAN='\e[1;36m'        # Cyan
BWHIHTE='\e[1;37m'      # White





####################################################
#
# FUNCTIONS
#
####################################################

function usage {

    echo "Usage: $(basename $0) [--admin | --connect <hostname> <username>]"
    echo ""
    echo "  -h, --help       show this help message and quit"
    echo "  -a, --admin      log in the virtual machine as administrator"
    echo "  -c, --connect    log in the virtual machine as simple user"
    echo "                   you must specify the hostname and the username."
    echo "                   (you can connect as a guest, use guest for both username and hostname)"
    echo ""
    
    exit 1

}


#
# DOCUMENTATION help_cmd
# les cmd sont lues a partie des fichier .admincmd et .usercmd
#

function help_cmd {

    local mode="$1"
    local file=""

    if [ "$mode" = "admin" ]
    then

        file=$PWD/.admincmd

    else

        file=$PWD/.usercmd

    fi
    
    # on lit le fichier d'aide associé au mode
    echo -en "$(head -2 $file)\n\n"
    echo -en "$(cat $file | awk -F':' 'NR > 2 {printf "\e[0;33m%-12s\e[0m:%s\n", $1, $2}')\n\n" # don't touch it i'm very proud of that

}



#
# DOCUMENTATION write_logs
# le mode signifie si c'est une deconnexion ou un connexion
#
function write_logs {

    local username="$1"
    local hostname="$2"
    local message="$3"

    local rep_log=$(date +%F) # nom du dossier de log
    local prompt_log=$(date | awk '{printf "%s %s %s %s %s",  substr($1,0, 4), $2, $3, $4, $5}' | sed 's/,/ --/')
    

    # si le dossier de log n'existe pas, on le cree
    if [ ! -d /home/rvsh/log/$rep_log ]
    then
	    mkdir -p /home/rvsh/log/$rep_log
    fi
    
    
    echo -e "${prompt_log} >  $username @ $hostname: $message" >> /home/rvsh/log/$rep_log/syslogs
}   



#
# DOCUMENTATION handle_admin_cmd
#
function handle_admin_cmd {

    local cmd=""    # commande entree par l'utilisateur
    local admin_prompt="${RED}rvsh >${NC}"

    # on ecrit les logs
    write_logs "admin" "rvsh" "connected"
    
    
    while [ "$cmd" != "quit" ]
    do
        echo -en "$admin_prompt "
        read cmd
        
        # lecture de la commande entree
        case "$cmd" in

            'quit') 
                
                ;;

            'clear')
                clear
                ;;

            'afinger')
                echo "[*] commande en dev..."
                ;;

            'host')
                echo "[*] commande en dev..."
                ;;
            'user')
                echo "[*] commande en dev..."
                ;;
            
            '')
                continue
                ;;

            '?') 
                help_cmd "admin"
                ;;

            *) 
                echo -e "${YELLOW}$cmd : Commande non reconnue, '?' pour afficher les commandes disponnibles${NC}"
                ;;
        esac
    
   done

    write_logs "admin" "rvsh" "disconnected"

}


#
# DOCUMENTATION handle_admin_cmd
#
function handle_user_cmd {


    local username="$1"
    local hostname="$2"
    local cmd=""    # commande entree par l'utilisateur
    local user_prompt="${GREEN}${username}@${hostname} >${NC}"

    write_logs "$username" "$hostname" "connected"
    
    
    while [ "$cmd" != "quit" ]
    do
        echo -en "$user_prompt "
        read cmd
        
        # lecture de la commande entree
        case "$cmd" in

            'quit') 
                
                ;;

            'clear')
                clear
                ;;

            'who')
                echo "[*] commande en dev..."
                ;;

            'rusers')
                echo "[*] commande en dev..."
                ;;
            'rhost')
                echo "[*] commande en dev..."
                ;;

            'connect')
                echo "[*] commande en dev..."
                ;;

            'su')
                echo "[*] commande en dev..."
                ;;

            'passwd')
                echo "[*] commande en dev..."
                ;;

            'finger')
                echo "[*] commande en dev..."
                ;;

            'write')
                echo "[*] commande en dev..."
                ;;

            '')
                continue
                ;;

            '?') 
                help_cmd "user"
                ;;

            *) 
                echo -e "${YELLOW}$cmd : Commande non reconnue, '?' pour afficher les commandes disponnibles${NC}"
                ;;
        esac

   done

   write_logs "$username" "$hostname" "disconnected"
}






####################################################
#
# SCRIPT BEGINING
#
####################################################


# parse the command line
ARGS=$(getopt -o hac: -l "help,admin,connect:" -n "rvsh.sh" -- "$@");
eval set -- $ARGS
    
# variables
admin_flag=""
user_flag=""
hostname=""
username=""


# not enough arguments
if [ $# -eq 1 ]
then 
    usage
fi


while true; do
    
    case "$1" in
            
        -h | --help)
        shift
        usage
        ;;
            
            
        -a | --admin)
        shift
        admin_flag="on"
        
        break
        ;;
            
        -c | --connect)
        shift
        user_flag="on"
        hostname="$1"
        shift 2

        if [ -z "$1" ] 
        then
            echo "Vous devez preciser le nom d'utilisateur..."
            exit
        else
            username="$1"
        fi 
        
        break
        ;;
            
        --)
        shift;
        break;
        ;;

    esac

done


# si le mode administrateur est actif 
# il prime sur le mode utilisateur 
#
if [ "$admin_flag" = "on" ]
then
    
    md5_pass="6f55b656e660c72e2e38b8a68c598703"
    read -p "[*] administrator password: " -s pass
    
    if [ "$(echo "$pass" | md5sum | cut -d' ' -f1 )" = "$md5_pass" ]
    then
        echo ""
        handle_admin_cmd
    else
        echo -e  "\n[!] wrong password for administrator"
        exit
    fi

elif [ "$user_flag" = "on" -a -z "$admin_flag" ]
then

    handle_user_cmd $username $hostname

else

    exit

fi

####################################################
#
# SCRIPT END
#
####################################################
