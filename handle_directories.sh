#===================================================================================
# file         : handle_directories.sh
# usage        : ---
#
# description  : fichier source des commandes cd, ls, mkdir, rmdir, pwd.
#
# options      : ---
# authors      : G. MAHFOUDI & S. JUHEL
# company      : UTT
# version      : 1.0
# bugs         : ---
# notes        : ---
# created      : ---
# revision     : ---
#===================================================================================


# repertoire racine de rvsh
ROOT="/home/rvsh"

move_location(){

	local old_location=$1
	local direction=$2
	new_location=$old_location

	if [ "$direction" = ".." ]
	then
		new_location=$(echo $old_location | awk -F "/" '{for (i=1; i < NF; i++) {printf "/%s", $i}}')
	else
		new_location=$old_location/$direction
		echo $new_location
	fi
} 

cd() {
	local old_location=$1
	local _direction=$2
	local type_of_user=$3

	_new_location=$old_location

	if [ "$type_of_user" = "admin" ]
	then
		if [ "$_direction" = ".." ]
		then

			if [ "$old_location" != "/$type_of_user" ]
			then
				move_location $old_location $_direction
				echo $old_location
				_new_location=$new_location
			fi

		else
			if [ ! "$(ls $HOME$old_location | grep $_direction)" = "" ]
			then
				move_location $old_location $_direction
				_new_location=$new_location
			else
				echo "No such a directorie"
				_new_location=$old_location
			fi
		fi
	else
		if [ "$_direction" = ".." ]
		then

			if [ "$old_location" != "/$type_of_user" ]
			then
				move_location $old_location $_direction
				_new_location=$new_location
			fi
		else
			if [ ! "$(ls $HOME/rvsh$old_location | grep $_direction)" = "" ]
			then
				move_location $old_location $_direction
				_new_location=$new_location
			else
				echo "No such a directorie"
				_new_location=$old_location
			fi
		fi
	fi
}

ls() {
	ls $HOME$1
}

rmdir() {
	exit
}

mkdir() {
	exit
}

pwd() {
	exit
}