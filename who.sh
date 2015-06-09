#===================================================================================
# file         : who.sh
# usage        : ---
#
# description  : fichier source de la commande who.
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



#=== function ======================================================================
# name         : who_is_connected_on
# description  : permet d'acceder à l'ensemble des utilisateurs connectés sur
#                la machine virtuelle. 
#
# parameters   :
# $1 - nom de la machine virtuelle
#===================================================================================
who_is_connected_on() {

	local hostname="$1"
	
	if [ ! -d $ROOT/host/$hostname ]; then
		echo "Host $hostname does not exist"
		
	else

		
		# on parcours l'ensemble des fichiers de connexion de la
		# machine

		ret=$(ls $ROOT/host/$hostname/*.tmp 2> /dev/null)
		if [ -z "$ret" ]; then
			return
		else

			printf "(host) $hostname\n"
			printf "%-12s %-9s %-9s\n" "user" "hour" "date"
			echo   "------------ --------  --------"

			for conn in $ret; do

				# affichage formate des connexions trouvees dans le fichier
				cat $conn | awk -F',' '{printf "%-12s %-9s %-9s\n", $1, $2, $3}'
				
			done
			
		fi

		printf "\n"
	fi
}