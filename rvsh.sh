#!/bin/bash
#
#
#

clear

################## function ##################

function badParam {
	echo -e "
Les paramètres entrés ne sont pas corrects. 
Utilisation de rvsh : 
rvsh [mode de connection] [utilisateur] [machine]
Mode de connection :
	-connect accéder aux machines en tant qu'utilisateur.
	-admin accéder à l'interface administrateur

"
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

function host {

    if [ ! -d /home/.rvsh/$1 ]
    then
        sudo mkdir /home/.rvsh/$1
    fi

}


function handleCmd {
	
	tmp=($1)
    
	msg=${tmp[0]}
	mode="$2"
	param=${tmp[1]}
	
	echo "msg = $msg    param = $param"
	
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


	        "?" ) commandeList;;

	        * ) echo "$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles";;
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
	        
	        #Création d'un hôte
	        "host" ) host $param;;


	        "?" ) commandeList;;

	        * ) echo "$msg : Commande non reconnue, '?' pour afficher les commandes disponnibles";;
	    esac
	    
    fi
    
    

}



##################  Script  ##################


#Initialisation de rvsh

if [ ! -d /home/.rvsh ]
then
	sudo mkdir -p /home/.rvsh
fi


#Paramètre rvsh
connectMode=$1
user=$2
machine=$3




#Ici se déroule la magie de l'aide
if [ "$connectMode" == "-h" ]
then
	h
	exit
fi




#Gestion des erreurs de paramètres
#TODO rendre les if plus compact si possible
if [ "$connectMode" != "-connect" ]
then
	if [ "$connectMode" != "-admin" ]
	then
		badParam
		exit
	fi
fi

if [ "$connectMode" == "-connect" ]	
then
	if [ "$user" == "" -o "$machine" == "" ]
	then
		badParam
		exit
	fi 
fi

#variable qui reçoit les commandes saisies
cmd=""


#Démarrage du prompt suivant le mode de connection
if [ "$connectMode" == "-connect" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "$user@$machine > " cmd
		handleCmd "$cmd" $connectMode
	done

fi


if [ "$connectMode" == "-admin" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "rvsh > " cmd
		handleCmd "$cmd" $connectMode
	done

fi






