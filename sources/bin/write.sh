#!/bin/bash

# Ecriture des messages pour d'autre utilisateurs

ROOT="$HOME/rvsh"

# Ecriture d'un message à un autre utilisateur
# $1 identifiant de connexion de la forme utilisateur@machine puis le message
# $2 utilisateur qui envoie le message
# TODO : Vérifier que la paire Utilisateur@Machine existe.
write() {

	cible=($1)
	cible=${cible[0]}

	msg=${1:$((${#cible[0]}+1))}

	cible=$(echo $cible | awk -F "@" '{print $1}')
	

	if [ ! -d $ROOT/users/$cible/msg/ ]
	then
		mkdir $ROOT/users/$cible/msg/
	fi

	

	echo


	sender="$2.$(date +%H%M%N)"

	echo -e $msg > $ROOT/users/$cible/msg/$sender

}