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

	if 	[ "$(echo $location/$dir_name | awk -F "/" '{print $(NF-1)}')" = "host" ] || \
		[ "$(echo $location/$dir_name | awk -F "/" '{print $(NF-1)}')" = "users" ] || \
		[ "$(echo $location/$dir_name | awk -F "/" '{print $(NF-1)}')" = "sys" ]
	then	#On vérifie que l'on ne suprimme pas des dossiers ou fichiers systèmes
		echo "You cannot remove $location$dir_name"
		return
	fi

	if [ "$user" = "admin" ]		#Si on est l'administrateur
	then

		case $location in
			"/rvsh" ) #Si on appelle la commande depuis le dossier rvsh
					if [ "$dir_name" = "host" -o "$dir_name" = "users" -o "$dir_name" = "sys/logs" -o "$dir_name" = "sys/help" ]
					then  #On vérifie que l'on ne supprime pas un host ou un user ou l'aide ou les logs
						echo "You cannot remove $dir_name"
					else
						if [ \( -d ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) -o \
						     \( -e ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) ]
						then
							rm -r ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
						else
							echo "No such a directory"
						fi
					fi
				;;

			"/rvsh/host" | "/rvsh/users" ) #Si on appelle la commande depuis le dossier rvsh/host ou /users
					echo "You cannot remove directories from $location"
				;;

			*		)						#Si on appelle la commande depuis un autre dossier

					if [  "$(echo $location | awk -F "/" '{print $(NF-1)}')" != "host" -a "$(echo $location | awk -F "/" '{print $(NF-1)}')" != "users" ]
					then		#On vérifie que l'on ne supprime pas un host ou un user
						if [ \( -d ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) -o \
						     \( -e ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) ]
						then	#Si le dossier existe on le suprimme
							rm -r ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
						else
							echo "No such a directory"
						fi
					else
						echo "You cannot remove directories from $location"
					fi
				;;
		esac

	else
		if [ \( -d ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) -o \
						     \( -e ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}') \) ]
		then 	#L'utilisateur peut supprimer n'importe quel dossier/fichier de son arborescence. Si celui ci existe.
			rm -r ${HOME}${location}/$(echo ${dir_name} | awk -F' ' '{print $1}')
		else
			echo "No such a directory"
		fi
	fi
}
