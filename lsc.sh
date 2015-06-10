# =====================================================================
#
#           FILE : lsc.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande lsc
#
#
#         OPTION : voir la fonction help_lsc
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === INCLUDES ========================================================

source rusers.sh
source who.sh

# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === FUNCTION ========================================================
#
#        name: help_lsc
# description: affiche l'aide en ligne de la commande 'lsc'
# 
#  parameters: ---
#
# =====================================================================
help_lsc() {
	echo "usage: lsc [-ham] "
	echo ""
	echo "  -h          show this help and quit."
	echo "  -a          list connected users on all host"
	echo "  -m <host>   list connected users on host"
	echo ""
}


# === FUNCTION ========================================================
#
#        name: lsc
# description: permet à l'administrateur d'afficher les utilisateurs
#              connectés sur une machines ou sur toutes les machines 
#              du réseau.
# 
#  parameters: ---
#
# =====================================================================
lsc() {
    
    local OPTIND
    
    getopts "am:h" opt

    case "$opt" in
        "h" ) help_lsc;;
        "a" ) rusers;;                      # on affiche qui est connecté sur toute les machines.
        "m" ) who_is_connected_on $OPTARG;; # on affiche qui est connecté sur la machine spécifiée
         *  ) help_lsc;;
    esac
}


# === END OF FILE =====================================================