#!/bin/bash
#
#
#



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
	done

fi


if [ "$connectMode" == "-admin" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "Admin@AdminMachine # " cmd
	done

fi






