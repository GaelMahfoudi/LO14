#===================================================================================
# file         : rusers.sh
# usage        : ---
#
# description  : fichier source de la commande rusers.
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
ROOT="$HOME/rvsh"

#=== includes ======================================================================

source who.sh

#=== end includes ==================================================================


#=== function ======================================================================
# name         : rusers
# description  : permet d'acceder à la liste des utilisateurs connectés sur
#				 le réseau virtuel.
#                
# parameters   : ---
# returns      : --- 
#===================================================================================
rusers() {

	# pour chaque machines du réseau virtuel
	for host in $(ls $ROOT/host/); do

		# on execute la commande who_is_connected
		who_is_connected_on $host

	done
}