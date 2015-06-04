#!/bin/bash 

# =====================================================================
#
#           FILE : cd.sh
#
#          USAGE : cd.sh [dossier] 
#
#    DESCRIPTION : Permet à l'utilisateur ou l'administrateur de 
#				   dans l'arborescence des machines.
#
#
#         OPTION : voir fonction help_cd.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================

source movelocation.sh



cd() {

	local old_location=$1
	local direction=$2
	local type_of_user=$3

	_new_location=$old_location

	if [ "$type_of_user" = "admin" ]
	then
		if [ "$direction" = ".." ]
		then
			nbf=$(echo $old_location | sed 's/\// /g')
			nbf=($nbf)
			nbf=${#nbf}

			if [ "$nbf" != "2" ]
			then
				move_location $old_location $direction
			fi

		else
			if [ ! "$(ls $HOME$old_location | grep $direction)" = "" ]
			then
				move_location $old_location $direction
				_new_location=$new_location
			else
				echo "No such a directorie"
				_new_location=$old_location
			fi
		fi
	else
		if [ "$direction" = ".." ]
		then
			nbf=$(echo $old_location | sed 's/\// /g')
			nbf=($nbf)
			nbf=${#nbf}

			if [ "$nbf" != "2" ]
			then
				move_location $old_location $direction
				_new_location=$new_location
			fi
		else
			if [ ! "$(ls $HOME/rvsh$old_location | grep $direction)" = "" ]
			then
				move_location $old_location $direction
				_new_location=$new_location
			else
				echo "No such a directorie"
				_new_location=$old_location
			fi
		fi
	fi

}
