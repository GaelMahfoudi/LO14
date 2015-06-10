#!/bin/bash 

# =====================================================================
#
#           FILE : rvsh_rm.sh
#
#          USAGE : rvsh_rm [dossier ou fichier] 
#
#    DESCRIPTION : Permet à l'utilisateur ou l'administrateur de 
#				   supprimmer des dossiers/fichiers dans l'arborescence.
#
#
#         OPTION : voir fonction help_cd.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================


rvsh_rm() {

	local location=$1
	local dir_name=$2
	local user=$3

	if 	[ "$(echo $location$dir_name | awk -F "/" '{print $(NF-1)}')" = "host" ] || \
		[ "$(echo $location$dir_name | awk -F "/" '{print $(NF-1)}')" = "users" ] || \
		[ "$(echo $location$dir_name | awk -F "/" '{print $(NF-1)}')" = "sys" ]
	then
		echo "You cannot remove $location$dir_name"
		return
	fi

	if [ "$user" = "admin" ]
	then

		case $location in
			"/rvsh" )
					if [ "$dir_name" = "host" -o "$dir_name" = "users" -o "$dir_name" = "sys/logs" -o "$dir_name" = "sys/help" ]
					then 
						echo "You cannot remove $dir_name"
					else
						if [ \( -d ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) -o \( -e ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) ]
						then
							rm -r ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
						else
							echo "No such a directory"
						fi
					fi
				;;

			"/rvsh/host" | "/rvsh/users" )
					echo "You cannot remove directories from $location"
				;;

			*		)

					if [  "$(echo $location | awk -F "/" '{print $(NF-1)}')" != "host" -a "$(echo $location | awk -F "/" '{print $(NF-1)}')" != "users" ]
					then
						if [ \( -d ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) -o \( -e ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) ]
						then
							rm -r ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
						else
							echo "No such a directory"
						fi
					else
						echo "You cannot remove directories from $location"
					fi
				;;
		esac
	fi
}