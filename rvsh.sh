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

# Voici toute les couleurs en normal et en gras
# attendre avant de les ajouter
# car modification de certains morceaux de code necessaires

# # Regular Colors
# BLACK='\e[0;30m'        # Black
# RED='\e[0;31m'          # Red
# GREEN='\e[0;32m'        # Green
# YELLOW='\e[0;33m'       # Yellow
# BLUE='\e[0;34m'         # Blue
# PURPLE='\e[0;35m'       # Purple
# CYAN='\e[0;36m'         # Cyan
# WHITE='\e[0;37m'        # White

# # Bold
# BBLACK='\e[1;30m'       # Black
# BRED='\e[1;31m'         # Red
# BGREEN='\e[1;32m'       # Green
# BYELLOW='\e[1;33m'      # Yellow
# BBLUE='\e[1;34m'        # Blue
# BPURPLE='\e[1;35m'      # Purple
# BCYAN='\e[1;36m'        # Cyan
# BWHISTE='\e[1;37m'      # White


ORANGE='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'


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
# DOCUMENTATION write_logs
#
function write_logs {

    local username="$1"
    local hostname="$2"

    local rep_log=$(date +%F) # nom du dossier de log
    local prompt_log=$(date | awk '{print $1, $2, $3, $4, $5}' | sed 's/,/ --/')
    

    # si le dossier de log n'existe pas, on le cree
    if [ ! -d /home/rvsh/log ]
    then
	    mkdir /home/rvsh/log
    fi
    
    # on cree le dossier de log du jour si il n'existe pas
    if [ ! -d /home/rvsh/log/$rep_log ]
    then
	    mkdir /home/rvsh/log/$rep_log
    fi
    
    echo -e "${prompt_log} >  $username connected in $hostname" >> /home/rvsh/log/$rep_log/syslogs
}


function handle_admin_cmd {

    local cmd=""    # commande entree par l'utilisateur
    local admin_prompt="${RED}rvsh >${NC}"

    # on ecrit les logs
    write_logs "admin" "rvsh"
    
    
    while [ "$cmd" != "quit" ]
    do
        read -p "$admin_prompt " cmd

        
   done

}

# #Affiche la liste des commandes disponnibles et une petite aide
# function commandeList {
#     echo -e "
# exit : quitte rvsh  (Possibilité de taper 'e')
# clear : efface le contenu de l'écran (Possibilité de taper 'c')
# ? : affiche la liste des commandes disponnibles. La syntaxe [nom_commande]? affiche l'aide pour cette commande.
# "
# }


# function handleCmd {
	
# 	tmp=($1)
#     mode="$2"
    
# 	msg=${tmp[0]} #On récupère le premier mot de tmp qui est la commande
# 	param=${1:${#msg}} #On récupère les mots suivants qui sont les paramètres
	
	
# 	if [ $mode = "-connect" ]
# 	then
# 	    case "$msg" in
	
# 	        #Gestion de la sortie
# 	        "exit" ) clear;
# 	        exit;;
# 	        "e" ) clear;
# 		    exit;;

# 	        #Effacement de l'écran
# 	        "clear" ) clear;;
# 	        "c" ) clear;;
# 	        "cl" ) clear;;
	        
# 	        #commande who
# 	        "who" ) whoIsConnected;;

# 	        "?" ) commandeList;;

# 	        * ) echo -e "${White}$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles$NC";;
# 	    esac
	    
# 	else
	
# 	    case "$msg" in
	
# 	        #Gestion de la sortie
# 	        "exit" ) clear;
# 		    exit;;
# 	        "e" ) clear;
# 		    exit;;

# 	        #Effacement de l'écran
# 	        "clear" ) clear;;
# 	        "c" ) clear;;
# 	        "cl" ) clear;;
	        
# 	        #Gestion des host
# 	        "host" ) host $param;;
# 	        "hostlist" ) hostList;;
	        
# 	        #Gestion des users
# 	        "user" ) user $param;;
	        
# 	        #commande who
# 	        "who" ) whoIsConnected;;


# 	        "?" ) commandeList;;

# 	        * ) echo -e "${White}$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles$NC";;
# 	    esac
	    
#     fi
    
    

# }



# function userMode {

#     userName=$2
#     hostName=$3
    
#     if [ "$userName" = "guest" -a "$hostName" = "guest" ]
#     then
#         echo -e "${White}You are connected as guest user.$NC"
#         hostName="guest-host"
#         userName="guest"
#     fi

#     write_logs $userName $hostName
    
# 	while [ ! "$cmd" = "exit" ]
# 	do
# 	    echo -e -n "${Red}$userName${Orange}@${Red}$hostName > ${White}"
# 		read cmd
# 		echo -e -n "$NC"
# 		handleCmd "$cmd" $1
# 	done
# }

# function admin_mode {


#     write_logs "Admin" "rvsh"
    
# 	while [ ! "$cmd" = "exit" ]
# 	do
# 	    echo -e -n "${Red}rvsh > $White"
# 		read  cmd 
# 		echo -e -n "$NC"
# 		handleCmd "$cmd" $1
# 	done

# }



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
        #admin_mode "-admin" # ?????
        ;;
            
        -c | --connect)
        shift
        user_flag="on"
        hostname="$1"
        shift 2
        username="$1"

        #userMode "-connect" $USERNAME $HOSTNAME    
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
    admin_mode
fi

####################################################
#
# SCRIPT END
#
####################################################
