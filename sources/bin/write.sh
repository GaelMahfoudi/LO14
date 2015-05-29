#!/bin/bash

# Ecriture des messages pour d'autre utilisateurs

ROOT="$HOME/rvsh"

# Ecriture d'un message à un autre utilisateur
# $1 identifiant de connexion de la forme utilisateur@machine puis le message
# $2 utilisateur qui envoie le message
write() {

	if [ ! -d $ROOT/users/$2/msg/ ]
	then
		mkdir $ROOT/users/$2/msg/
	fi

	cible=($1)
	cible=${cible[0]}

	msg=${1:${#cible[0]}}

	sender="$1.$(date +%H%M%N)"

	echo -e $msg > $ROOT/users/$2/msg/$sender

}