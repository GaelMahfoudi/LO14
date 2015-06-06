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

source rusers.sh
source who.sh

# repertoire racine de rvsh
ROOT="/home/rvsh"


help_whoison() {
	echo "usage: whoison [host | all]"
	echo ""
	echo "  host  users on the host machine"
	echo "  all     users on all machines"
	echo ""
}


#=== function ======================================================================
# name         : whoison
# description  : permet d'acceder à l'ensemble des utilisateurs connectés sur
#                une machine virtuelle spécifiée. 
#
# parameters   :
# $1 - nom de la machine virtuelle
#===================================================================================
whoison() {

	local hostname="$1"

	if [ -z "$hostname" ]; then
		help_whoison
	elif [ "$hostname" = "all" ]; then
		rusers
	elif [ ! -d $ROOT/host/$hostname ]; then	
		echo "Host $hostname does not exists"
	else
		who_is_connected_on $hostname
	fi
}