#!/bin/bash 

# =====================================================================
#
#           FILE : ls.sh
#
#          USAGE : ls [Dossier]
#
#    DESCRIPTION : Permet à l'utilisateur ou l'administrateur d'afficher 
#				   le contenu du répertoire courant ou d'un dossier.
#
#
#         OPTION : 
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================



rvsh_ls() {

	local location=$1
	local cible=$2


	if [ "$cible" = "" ]
	then
		ls -F $HOME$location
	else
		if [ -d $HOME$location$cible ]
		then
			ls -F $HOME$location$cible
		else
			echo "$location$cible : No such a directory"
		fi
	fi
	
}