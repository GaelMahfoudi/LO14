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
#
# =====================================================================


# ==== HELP_CD ========================================================
#
#        NAME : help_cd
# DESCRIPTION : Affiche l'aide de la fonction cd.
# PARAMETER   : Pas de paramètre.
#
# =====================================================================
help_cd() {

	echo "usage: cd <directory>"
    echo ""
    echo "  <directory>  The destination you want to reach. '..' allow you to go backward."
    echo ""
}



move_location() {

	local old_location=$1
	local direction=$2
	new_location=$old_location

	if [ "$direction" = ".." ]
	then
		new_location=$(echo $old_location | awk -F "/" '{for (i=2; i < NF; i++) {printf "/%s", $i}}')
	else
		new_location=$old_location"/$direction"
	fi
} 

# ==== CD =============================================================
#
#        NAME : cd
# DESCRIPTION : Permet de se déplacer dans l'arborescence rvsh.
# PARAMETER $1: L'ancien emplacement de l'utilisateur.
#			$2: L'emplacement ou l'on souhaite se déplacer.
#			$3: Nom de l'utilisateur.
#			$4: La machine de l'utilisateur.
# =====================================================================
rvsh_cd() {

	local old_location=$1
	local _direction=$2
	local type_of_user=$3
	local host=$4

	_new_location=$old_location

	if [ "$_direction" = "" ] #Si aucune direction n'est précisée on affiche l'aide
	then
		help_cd
		return
	fi

	if [ "$type_of_user" = "admin" ] 	#Si l'utilisateur est l'administrateur
	then

		case $_direction in 			#On traite la demande de l'utilisateur

			'..') #Si il demande à retourner en arrière.

				if [ "$old_location" != "/rvsh" ] #On vérifie qu'il n'est pas déjà en haut de l'arborescence
				then
					move_location $old_location $_direction
					_new_location=$new_location
				fi
				;;

			*   ) #Pour tout autre demande

				if [ ! "$(ls $HOME$old_location | grep $_direction)" = "" ] #On vérifie que l'emplacement demandé existe 
				then
					if [ -d $HOME$old_location/$_direction ]                #On vérifie que l'emplacement est un dossier
					then
						move_location $old_location $_direction
						_new_location=$new_location
					else
						echo "$_direction : not a directory"
					fi
				else
					echo "No such a directorie"
					_new_location=$old_location
				fi
				;;
		esac

	else										#Si l'utilisateur n'est pas administrateur

		case $_direction in

			'..') #Si il demande à retourner en arrière.

				if [ "$old_location" != "/rvsh/host/$host/$type_of_user" ] #On vérifie qu'il n'est pas déjà en haut de l'arborescence
				then
					move_location $old_location $_direction
					_new_location=$new_location
				fi
				;;

			*   ) #Pour tout autre demande

				if [ ! "$(ls $HOME$old_location | grep $_direction)" = "" ] #On vérifie que l'emplacement demandé existe
				then
					if [ -d $HOME$old_location/$_direction ]
					then
						move_location $old_location $_direction				#On vérifie que l'emplacement est un dossier
						_new_location=$new_location
					else
						echo "$_direction : not a directory"
					fi
				else
					echo "No such a directorie"
					_new_location=$old_location
				fi
				;;

		esac
	fi

}
