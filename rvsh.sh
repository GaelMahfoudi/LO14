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
    echo "                   you must specify the hostname and the username"
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

    ls /home/rvsh/host

}

function userList {

    ls /home/rvsh/user

}

function host {

    if [ ! -d /home/rvsh/host ]
    then 
        mkdir /home/rvsh/host
    fi


    if [ ! -d /home/rvsh/host/$1 ]
    then 
        mkdir /home/rvsh/host/$1
    else
        rmdir /home/rvsh/host/$1
    fi

}

function user {

    if [ ! -d /home/rvsh/user ]
    then 
        mkdir /home/rvsh/user
    fi

    if [ ! -d /home/rvsh/user/$1 ]
    then 
        mkdir /home/rvsh/user/$1
    else
        rmdir /home/rvsh/user/$1
    fi
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
    
    echo -e "
################# New connection #################
user : $1      host : $2         
date : $D
##################################################
" >> /home/rvsh/log/$d/logIn

}

function whoIsConnected {

    d=$(date +%F)
    
    echo -e "$Blue$(cat /home/rvsh/log/$d/logIn)$NC"
}

function handleCmd {
	
	tmp=($1)
    
	msg=${tmp[0]}
	mode="$2"
	param=${tmp[1]}
	
	
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
	        "userlist" ) userList;;
	        
	        #commande who
	        "who" ) whoIsConnected;;


	        "?" ) commandeList;;

	        * ) echo -e "${Blue}$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles$NC";;
	    esac
	    
    fi
    
    

}


function userMode {
    
    
    
    if [ ! -d /home/rvsh/user/$2 ]
    then
        echo "Uknown user"
        exit
    fi
    
    if [ ! -d /home/rvsh/host/$3 ]
    then
        echo "Uknown host"
        exit
    fi
    

    logInFunc $2 $3
    
	while [ ! "$cmd" = "exit" ]
	do
	    echo -e -n "${Orange}$2${Red}@${Orange}$3 > ${Green}"
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







