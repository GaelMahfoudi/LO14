#===================================================================================
# file         : lsc.sh
# usage        : ---
#
# description  : fichier source de la commande lsc.
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


help_lsc() {
	echo "usage: lsc [-ham] "
	echo ""
	echo "  -h          show this help and quit."
	echo "  -a          list connected users on all host"
	echo "  -m <host>   list connected users on host"
	echo ""
}



#=== function ======================================================================
# name         : lsc
# description  : permet d'acceder à l'ensemble des utilisateurs connectés sur
#                une machine virtuelle spécifiée ou sur toutes celles
# 				 du réseau. 
#
# parameters   :
# $1 - nom de la machine virtuelle
#===================================================================================
lsc() {
    
    local OPTIND
    
    getopts "am:h" opt

    case "$opt" in
        "h" ) help_lsc;;
        "a" ) rusers;;
        "m" ) who_is_connected_on $OPTARG;;
         *  ) help_lsc;;
    esac
}