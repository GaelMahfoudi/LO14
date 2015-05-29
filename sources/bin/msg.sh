#!/bin/bash 

# Fonction de bas de gestion
# du système de messagerie

ROOT="$HOME/rvsh"




# Affiche les messages reçus par l'utilisateurs
# $1 : utilisateurs en session

print_msg() {

	local msgList=$(ls $ROOT/users/$1/msg/)
	local msgCount=($msgList)

	local msg=""
	for i in $msgCount
	do
		echo -n "Message from $i : "
		msg=$(cat $ROOT/users/$1/msg/$i)
		echo -e "$msg"
	done

}

#Vérifie si l'utilisateur a reçu un ou plusieurs messages.
# $1 : Nom de l'utilisateur
check_msg() {

	if [ ! -d $ROOT/users/$1/msg/ ]

	local msgList=$(ls $ROOT/users/$1/msg/)
	local msgCount=($msgList)

	if [ "$msgList" = "" ]
	then
		echo "No new messages"
	else
		echo "You have ${msgCount[@]} new messages"
		print_msg
	fi
}

