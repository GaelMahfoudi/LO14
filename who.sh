#===================================================================================
# file         : who.sh
# usage        : ---
#
# description  : fichier source de la commande who.
#
# options      : see function ’usage’ below
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
# $1 - nom de la machine virtuelle
#
#===================================================================================
who_is_connected_on() {

	local hostname="$1"

	for conn in $(ls $ROOT/host/$hostname/*.tmp  2> /dev/null); do

		printf "$hostname:\n"
		printf "%-12s %-9s %-9s\n" "user" "hour" "date"
		echo   "------------ --------  --------"

		cat $conn | awk -F',' '{printf "%-12s %-9s %-9s\n", $1, $2, $3	}'
		printf "\n"
	done

}