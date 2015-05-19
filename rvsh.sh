#!/bin/bash
#
#
#



################## function ##################




##################  Script  ##################

cmd=""



#Paramètre rvsh
connectMode=$1
user=$2
machine=$3




#Gestion des erreurs de paramètres
#TODO rendre les if plus compact si possible
if [ "$connectMode" != "-connect" ]
then
	if [ "$connectMode" != "-admin" ]
	then
		echo "Error"
		exit
	fi
fi

if [ "$connectMode" == "-connect" ]	
then
	if [ "$user" == "" -o "$machine" == "" ]
	then
		echo "Error"
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






