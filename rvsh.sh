#!/bin/bash
#---------------------------------------------------
# title         : rvsh.sh 
# author        : G. Mahfoudi & S. JUHEL
# version       : 0.1    
# description   : ...
# bash_version  : 4.3.X-release
#---------------------------------------------------



source sources/sbin/host.sh
source sources/sbin/users.sh

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


ROOT="$HOME/rvsh"


####################################################
#
# FUNCTIONS
#
####################################################



# 'build_help'
#   constuit les fichier les fichiers d'aide principal de `rvsh.sh`
#   l'aide est accessible via `?` dans le prompt
#   construit 2 fichier:
#       admincmd: pour les commandes aministrateur
#       userscmd: pour les commandes utilisateur
#
function make_help {

    # admincmd
    echo 'Aide des commandes administrateur (tapez <cmd> -h pour plus de precrisions)

host: ajoute/enleve une machine du reseau virtuel
users: ajoute/enleve un utilisateur du reseau virtuel
afinger: renseigne des information complementaire sur un utilisateur' > $ROOT/.help/admincmd

    # userscmd
    echo 'Aide des commandes utilisateur (tapez <cmd> -h pour plus de precisions)

who: affiche la liste des utilisateurs connectes sur une VM
rusers: affiche la liste des utilisateurs connectes au reseau
rhost: affiche la liste des machines du reseau virtuel
connect: permet de se connecter a une autre machine
su: permet de change d utilisateur
passwd: change le mot de passe de l uitlisateur
finger: renvoie des elements complementaire sur l utilisateur
write: envoi un message a un utilisateur connecte' > $ROOT/.help/userscmd

}


# 'install'
#   fonction d'installation du programme
#   rvsh.sh
#
function install {

    declare -a directories
    directories[0]='host'               # dossier des VMs
    directories[1]='users'              # dossier des utilisateurs
    directories[2]='users/admin'        # dossier administrateur
    directories[3]='.logs'              # dossier des logs
    directories[4]='.help'              # dossier de l'aide principale des commandes


    echo "[*] installing $(basename $0)..."

    # creation du dossier de partage
    if [ -d $ROOT ]
    then
        echo "install> '$ROOT' already exists..."
    else
        echo "install> making home directory in '$ROOT'"
        mkdir $ROOT
    fi

    echo -e "install> added directories:"
    for dir in ${directories[*]}
    do
        
        echo -e "\t'$dir' has been created"
        mkdir $ROOT/$dir
            
    done

    
    make_help
    
    # admin password creation
    touch $ROOT/users/admin/password
    echo "6f55b656e660c72e2e38b8a68c598703" > $ROOT/users/admin/password     

    echo -e "install> Done."
}


# 'uninstall'
#   fonction de desinstallation du programme
#   rvsh.sh
#
function uninstall {


    if [ "$(whoami)" != "root" ]
    then

        echo "[error] uninstalling $(basename $0): you must be root..."
        exit

    else

        echo "[*] uninstall $(basename $0)..."
        # userdel rvsh         # suppression de l'utilisateur
        # groupdel rvsh        # suppression du groupe
        rm -r $ROOT        # suppression de l'architecture personnelle
        
    fi

    exit
}


# 'usage'
#   affiche l'aide de la commande `rvsh.sh`
#
usage() {

    echo "Usage: $(basename $0) [--admin | --connect <hostname> <username>]"
    echo ""
    echo "  -h, --help       show this help message and quit"
    echo "  -a, --admin      log in the virtual machine as administrator"
    echo "  -c, --connect    log in the virtual machine as simple user"
    echo "                   you must specify the hostname and the username."
    echo "                   (you can connect as a guest, use guest for both username and hostname)"
    echo "  -i, --install    install this program and exit"
    echo "  -u, --uninstall  uninstall this program and exit"
    echo ""
    
    exit 1
}


password() {

    local username="$1"
    local hostname="$2"


    if [ -e $ROOT/users/$username/password ]; then

        read -p "[CONNECTION] password for $username : " -s pass
        userpass=$(cat $ROOT/users/$username/password)


        if [ "$(echo "$pass" | md5sum | cut -d' ' -f1 )" = "$userpass" ]; then
            echo -e "[*] you are now logged as $username on $hostname\n"
            return 0  # success
        else
            echo -e "[!] bad password for user admin"
            return 1 # fail
        fi
    
    fi

    #=== NOTE ===============================
    # gerer le cas ou le fichier password
    # n'existe pas
    #========================================
}


connect() {
    
    local username="$1"
    local hostname="$2"


    # si connexion en mode admin
    if [ "$username" = "admin" ]; then
        
        password "admin" "rvsh" 

    else
        
        password "username" 

    fi
}


#
# DOCUMENTATION write_logs
# le mode signifie si c'est une deconnexion ou un connexion
#
write_logs() {

    local username="$1"
    local hostname="$2"
    local message="$3"

    local rep_log=$(date +%F) # nom du dossier de log
    local prompt_log=$(date | awk '{printf "%s %s %s %s %s",  substr($1,0, 4), $2, $3, $4, $5}' | sed 's/,/ --/')
    

    # si le dossier de log n'existe pas, on le cree
    if [ ! -d $ROOT/.log/$rep_log ]
    then
        mkdir -p $ROOT/.log/$rep_log
    fi
    
    echo -e "${prompt_log} >  $username @ $hostname: $message" >> $ROOT/.log/$rep_log/syslogs
} 



# 'help_cmd'
# 
help_cmd() {

    local mode="$1"
    local file=""

    if [ "$mode" = "admin" ]; then
        file=$ROOT/.help/admincmd
    else
        file=$ROOT/.help/userscmd
    fi
    
    # on lit le fichier d'aide associé au mode
    echo -en "$(head -2 $file)\n\n"
    echo -en "$(cat $file | awk -F':' 'NR > 2 {printf "\e[0;33m%-12s\e[0m:%s\n", $1, $2}')\n\n" # don't touch it i'm very proud of that
}


#
# DOCUMENTATION handle_admin_cmd
#
handle_admin_cmd() {

    local cmd=""    # commande entree par l'utilisateur
    local admin_prompt="${RED}rvsh >${NC}"
    
    while [ ! \( "$cmd" = "quit" -o "$cmd" = "q" \) ]; do
        echo -en "$admin_prompt "
        read tmp
        cmd=($tmp)
        cmd=${cmd[0]}
        param=${tmp:${#cmd}}
        
        
        
        # lecture de la commande entree
        case "$cmd" in

            'quit' | 'q') 
                
                ;;

            'clear' | 'c')
                clear
                ;;

            'afinger')
                echo "[*] commande en dev..."
                ;;

            'host')
                host $param
                ;;
            'users')
                user $param
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


function main {

    # parse the command line
    ARGS=$(getopt -o hac:iu -l "help,admin,connect:,install,uninstall" -n "rvsh.sh" -- "$@");
    eval set -- $ARGS
        
    # variables
    admin_flag=""
    user_flag=""
    install_flag=""
    uninstall_flag=""

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
                

            -i | --install)
            install
            break
            ;;

            -u | --uninstall)
            uninstall
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
    if [ "$admin_flag" = "on" ]; then
        
        connect "admin"

    elif [ "$user_flag" = "on" -a -z "$admin_flag" ]; then

        connect "$username"
        handle_user_cmd $username $hostname

    else

        exit

    fi

}

main "$@"

####################################################
#
# SCRIPT END
#
####################################################