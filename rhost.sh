#===================================================================================
# file         : rhost.sh
# usage        : ---
#
# description  : fichier source de la commande rhost.
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


#=== function ======================================================================
# name         : rhost
# description  : permet d'acceder à la liste des machines 
#				 rattachées au réseau virtuel.
# 
# parameters   : ---
#===================================================================================
rhost() {

	echo "Hosts available on the network:"

	# on liste le repertoire qui contients les machines
	list=$(ls $ROOT/host/)

	# si le repertoire est vide, on le précise
    if [ -z "$list" ]; then
        echo "No hosts created"
        
    # sinon on affiche la liste
    else
        echo "$list"
    fi

}