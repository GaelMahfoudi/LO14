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

help_cd() {

	echo "usage: cd <directory>"
    echo ""
    echo "  <directory>  The destination you want to reach. '..' allow you to go backward."
    echo ""
}


cd() {

	local old_location=$1
	local _direction=$2
	local type_of_user=$3

	_new_location=$old_location

	if [ "$_direction" = "" ]
	then
		help_cd
		return
	fi

	if [ "$type_of_user" = "admin" ]
	then

		case $_direction in

			'..')

				if [ "$old_location" != "/rvsh" ]
				then
					move_location $old_location $_direction
					_new_location=$new_location
				fi
				;;

			*   )

				if [ ! "$(ls $HOME$old_location | grep $_direction)" = "" ]
				then
					if [ -d $HOME$old_location/$_direction ]
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

	else

		case $_direction in

			'..')

				if [ "$old_location" != "/$type_of_user" ]
				then
					move_location $old_location $_direction
					_new_location=$new_location
				fi
				;;

			*   )

				if [ ! "$(ls $HOME/rvsh$old_location | grep $_direction)" = "" ]
				then
					if [ -d $HOME$/rvsh$old_location/$_direction ]
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
	fi

}
