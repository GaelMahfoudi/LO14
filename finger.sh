#!/bin/bash 
# =====================================================================
#
#           FILE : finger.sh
#
#          USAGE : finger.sh [utilisateurs] [-h]
#
#    DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#				   complémentaires de l'utilisateur spécifié.
#
#
#         OPTION : voir fonction help_finger.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================


ROOT="$HOME/rvsh"


help_finger() {

    echo "usage: finger [-h]"
    echo ""
    echo "  -h      show this help and quit"
    echo "  <user>  show this user info"
    echo ""


}

# ====  FINGER  =======================================================
#
#        NAME : finger
# DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#				complémentaires de l'utilisateur spécifié.
# PARAMETER $1: L'utilisateur spécifié.
# =====================================================================

function finger  {

	if [ "$1" = "" -o "$1" = "-h" ]
    then
        help_finger
        return
    fi
    
	mailList=$(cat $ROOT/users/$1/mails)
	phoneList=$(cat $ROOT/users/$1/phones)

	echo "-------------------------------------------------------------------------------"
	echo -e "\t\t\t\tInfo about $1"
	echo "-------------------------------------Mails-------------------------------------"
	echo $mailList
	echo "-------------------------------------Phones------------------------------------"
	echo $phoneList
	echo "-------------------------------------------------------------------------------"


}