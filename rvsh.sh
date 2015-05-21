#!/bin/bash
#
#
#

clear

Orange='\033[1;33m'
Green='\033[1;32m'
Blue='\033[1;34m'
Red='\033[1;31m'
NC='\033[0m'

################## function ##################

function usage 
{

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











function h {

	echo -e "
Utilisation de rvsh : 
rvsh [mode de connection] [utilisateur] [machine]
Mode de connection :
	-connect accéder aux machines en tant qu'utilisateur.
	-admin accéder à l'interface administrateur

"
}

#Affiche la liste des commandes disponnibles et une petite aide
function commandeList {
	echo -e "
exit : quitte rvsh  (Possibilité de taper 'e')
clear : efface le contenu de l'écran (Possibilité de taper 'c')
? : affiche la liste des commandes disponnibles. La syntaxe [nom_commande]? affiche l'aide pour cette commande.
"
}

function hostList {
    
    echo -e -n "$Blue"
    echo -e -n $(ls /home/rvsh/host)
    echo -e "$NC"

}

function userList {

    echo -e -n "$Blue"
    echo -e -n $(ls /home/rvsh/user)
    echo -e "$NC"
}

function addHost {
    if [ ! -d /home/rvsh/host/$1 ]
    then 
        mkdir /home/rvsh/host/$1
        echo -e "${Blue}The host $1 has been added.$NC"
    else
        echo -e "${Blue}The host $1 already exist.$NC"
    fi
}

function delHost {
    if [ -d /home/rvsh/host/$1 ]
    then 
        rmdir /home/rvsh/host/$1
        echo -e "${Blue}The host $1 has been removed.$NC"
    else
        echo -e "${Blue}The host $1 doesn't exist.$NC"
    fi
}

function host {
    
    if [ ! -d /home/rvsh/host ]
    then 
        mkdir /home/rvsh/host
    fi
    
    local OPTIND
    getopts "a:r:lh" OPTION
    
    case "$OPTION" in
        "a" ) addHost $OPTARG;;
        "r" ) delHost $OPTARG;;
        "l" ) hostList;;
        "h" ) echo "aide";;
    esac
    
}

function addUser {

    if [ ! -d /home/rvsh/user/$1 ]
    then 
        mkdir /home/rvsh/user/$1
        echo -e "${Blue}The user $1 has been added.$NC"
    else
        echo -e "${Blue}The user $1 already exist.$NC"
    fi
}

function delUser {

    
    if [ -d /home/rvsh/user/$1 ]
    then 
        rmdir /home/rvsh/user/$1
        echo -e "${Blue}The user $1 has been removed.$NC"
    else
        echo -e "${Blue}The user $1 doesn't exist.$NC"
    fi

}

function user {

    if [ ! -d /home/rvsh/user ]
    then 
        mkdir /home/rvsh/user
    fi
    
    local OPTIND
    
    getopts "a:r:lh" OPTION
    
    case "$OPTION" in
        "a" ) addUser $OPTARG;;
        "r" ) delUser $OPTARG;;
        "l" ) userList;;
        "h" ) echo "aide";;
    esac
}

function logInFunc {

    
    if [ ! -d /home/rvsh/log ]
    then
	    mkdir /home/rvsh/log
    fi
    
    d=$(date +%F)
    D=$(date)
    
    if [ ! -d /home/rvsh/log/$d ]
    then
	    mkdir /home/rvsh/log/$d
    fi
    
    echo -e "Connection:    
           User: $1
           Host: $2
           Date: $D      
" >> /home/rvsh/log/$d/logIn

}

function whoIsConnected {

    d=$(date +%F)
    
    echo -e "$Blue$(cat /home/rvsh/log/$d/logIn)$NC"
}

function handleCmd {
	
	tmp=($1)
    mode="$2"
    
	msg=${tmp[0]} #On récupère le premier mot de tmp qui est la commande
	param=${1:${#msg}} #On récupère les mots suivants qui sont les paramètres
	
	
	if [ $mode = "-connect" ]
	then
	    case "$msg" in
	
	        #Gestion de la sortie
	        "exit" ) clear;
	        exit;;
	        "e" ) clear;
		    exit;;

	        #Effacement de l'écran
	        "clear" ) clear;;
	        "c" ) clear;;
	        "cl" ) clear;;
	        
	        #commande who
	        "who" ) whoIsConnected;;

	        "?" ) commandeList;;

	        * ) echo -e "${Blue}$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles$NC";;
	    esac
	    
	else
	
	    case "$msg" in
	
	        #Gestion de la sortie
	        "exit" ) clear;
		    exit;;
	        "e" ) clear;
		    exit;;

	        #Effacement de l'écran
	        "clear" ) clear;;
	        "c" ) clear;;
	        "cl" ) clear;;
	        
	        #Gestion des host
	        "host" ) host $param;;
	        "hostlist" ) hostList;;
	        
	        #Gestion des users
	        "user" ) user $param;;
	        
	        #commande who
	        "who" ) whoIsConnected;;


	        "?" ) commandeList;;

	        * ) echo -e "${Blue}$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles$NC";;
	    esac
	    
    fi
    
    

}


function userMode {

    userName=$2
    hostName=$3
    
    if [ "$userName" = "guest" -a "$hostName" = "guest" ]
    then
        echo -e "${Blue}You are connected as guest user.$NC"
        hostName="guest-host"
        userName="guest"
    fi

    logInFunc $userName $hostName
    
	while [ ! "$cmd" = "exit" ]
	do
	    echo -e -n "${Orange}$userName${Red}@${Orange}$hostName > ${Green}"
		read cmd
		echo -e -n "$NC"
		handleCmd "$cmd" $1
	done
}

function adminMode {



    logInFunc "Admin" "rvsh"
    
	while [ ! "$cmd" = "exit" ]
	do
	    echo -e -n "${Orange}rvsh > $Green"
		read  cmd 
		echo -e -n "$NC"
		handleCmd "$cmd" $1
	done

}



##################  Script  ##################


# GLOBAL VARIABLES
USERNAME=""
HOSTNAME=""


ARGS=$(getopt -o hac: -l "help,admin,connect:" -n "rvsh.sh" -- "$@");
eval set -- $ARGS
    
    
if [ $# -eq 1 ]
then 
    usage
fi
    
    
while true; do
    
    case "$1" in
            
        -h | --help)
        shift;
        usage;
        ;;
            
            
        -a | --admin)
            shift;
            adminMode "-admin";
        exit;
        ;;
            
        -c | --connect)
            shift;
            HOSTNAME="$1";
            shift; shift;
            USERNAME="$1";
            userMode "-connect" $USERNAME $HOSTNAME;     
        exit;
        ;;
            
        --)
        shift;
        break;
        ;;
        
    esac
        
done







