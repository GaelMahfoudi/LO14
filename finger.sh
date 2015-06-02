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



# ====  FINGER  =======================================================
#
#        NAME : finger
# DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#				complémentaires de l'utilisateur spécifié.
# PARAMETER $1: L'utilisateur spécifié.
# =====================================================================

function finger  {
    
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