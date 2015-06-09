# =====================================================================
#
#           FILE : rusers.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande rusers
#
#
#         OPTION : ---
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === INCLUDES ========================================================

source who.sh

# =====================================================================


# === FUNCTION ========================================================
#
#        name: rusers
# description: permet d'acceder à la liste des utilisateurs connectés 
#              au réseau virtuel.
# 
#  parameters: ---
#
# =====================================================================
rusers() {

	# pour chaque machines du réseau virtuel
	for host in $(ls $ROOT/host/); do

		# on execute la commande who_is_connected_on
		who_is_connected_on $host

	done

}

# === END OF FILE =====================================================