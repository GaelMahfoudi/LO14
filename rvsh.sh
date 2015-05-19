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


function handleMsg {
	

	msg=$1
	
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


}



##################  Script  ##################

cmd=""



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




#Démarrage du prompt suivant le mode de connection
if [ "$connectMode" == "-connect" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "$user@$machine > " cmd
		handleMsg $cmd
	done

fi


if [ "$connectMode" == "-admin" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "Admin@AdminMachine # " cmd
		handleMsg $cmd
	done

fi






