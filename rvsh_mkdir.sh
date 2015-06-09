#!/bin/bash 

# =====================================================================
#
#           FILE : rvsh_mkdir.sh
#
#          USAGE : rvsk_mkdir [dossier] 
#
#    DESCRIPTION : Permet à l'utilisateur ou l'administrateur de 
#				   créer des dossiers dans l'arborescence.
#
#
#         OPTION : voir fonction help_cd.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================


rvsh_mkdir() {
	local location=$1
	local dir_name=$2

	if [ "$(echo $location$dir_name | awk -F "/" '{print $(NF-1)}')" = "host" -o "$(echo $location$dir_name | awk -F "/" '{print $(NF-1)}')" = "users" ]
	then
		echo "You cannot create $location$dir_name"
		return
	fi

	if [ "$(echo $location$dir_name | awk -F "/" '{print $(NF-2)}')" = "host" ]
	then
		echo "You cannot create $location$dir_name"
		return
	fi

	if [ "$location" = "/rvsh/host" -o "$location" = "/rvsh/users" ]
	then
		echo "You cannot create a directory at $location"
	else
		if [ "$(echo $location | awk -F "/" '{print $(NF-1)}')" = "host" ]
		then
			echo "You cannot create a directory at $location"
		else
			mkdir ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
		fi
	fi
}