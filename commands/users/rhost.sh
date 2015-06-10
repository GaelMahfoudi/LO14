# =====================================================================
#
#           FILE : rhost.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande rhost
#
#
#         OPTION : ---
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === FUNCTION ========================================================
#
#        name: rhost
# description: permet d'acceder à la liste des machines rattachées
#              au réseau virtuel.
# 
#  parameters: ---
#
# =====================================================================
rhost() {

	echo "Hosts available on the network:"

	# on recupere la liste des machines du repertoire
    # des machines
	list=$(ls $ROOT/host/)


	# le repertoire est vide
    if [ -z "$list" ]; then
        echo "No hosts created"
        
    # sinon on affiche la liste
    else
        echo "$list"
    fi

}

# === END OF FILE =====================================================