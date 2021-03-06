#!/bin/bash 

# =====================================================================
#
#           FILE : msg.sh
#
#          USAGE : msg.sh
#
#    DESCRIPTION : Fonction utilitaire liée à la messagerie.
#
#
#         OPTION : voir fonction check_msg.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================

ROOT="$HOME/rvsh"

YELLOW='\e[0;33m'       # Yellow
NC='\e[0m'       # Text Reset





# ====  PRINT_MSG  ====================================================
#
#        NAME : print_msg
# DESCRIPTION : Affiche les messages reçus par l'utilisateurs.
# PARAMETER $1: L'utilisateur dont on veut afficher les messages.
# =====================================================================

print_msg() {

	local msgList=$(ls $ROOT/users/$1/msg)
	local msgCount=($msgList)

	local msg=""
	for i in $(ls $ROOT/users/$1/msg)
	do
		name=$(echo $i | awk -F "." '{print $1}')
		echo -en "${YELLOW}Message from $name : $NC"
		msg=$(cat $ROOT/users/$1/msg/$i)
		echo -e "$msg"
		rm $ROOT/users/$1/msg/$i
	done

}

#Vérifie si l'utilisateur a reçu un ou plusieurs messages.
# $1 : Nom de l'utilisateur

# ====  CHECK_MSG  ====================================================
#
#        NAME : check_msg
# DESCRIPTION : Vérifie si l'utilisateur a de nouveaux messages.
# PARAMETER $1: L'utilisateur dont on veut vérifier si il a de 
#				de nouveaux messages.
# =====================================================================

check_msg() {

	if [ ! -d $ROOT/users/$1/msg/ ]
	then
		mkdir $ROOT/users/$1/msg/
	fi

	local msgList=$(ls $ROOT/users/$1/msg)
	local msgCount=($msgList)

	if [ "$msgList" != "" ]
	then
		echo -e "You have $YELLOW${#msgCount[@]}$NC new messages : "
		print_msg $1
	fi
}

