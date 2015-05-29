#!/bin/bash

# Ecriture des messages pour d'autre utilisateurs



# Ecriture d'un message à un autre utilisateur
# $1 identifiant de connexion de la forme utilisateur@machine puis le message
# $2 utilisateur qui envoie le message
write() {

	cible=($1)
	cible=${cible[0]}

	msg=${1:${#cible[0]}}


}