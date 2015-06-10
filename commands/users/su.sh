# =====================================================================
#
#           FILE : su.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande su
#
#
#         OPTION : voir fonction help_switch_user.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === INCLUDES ========================================================

source commands/shared/handle_connections.sh

# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === FUNCTION ========================================================
#
#        name: help_switch_user
# description: affiche l'aide en ligne de la commande 'switch_user'
# 
#  parameters: ---
#
# =====================================================================
help_switch_user() {

	echo "usage: su <user>"
	echo "    su allow you to switch user on the host"
	echo ""

}


# === FUNCTION =========================================================
#
#        name: switch_user
# description: permet de changer d'utilisateur
#
#  parameters:
# 	$1 - le nom du nouvel utilisateur
# 	$2 - le nom de la machine courante
#
# ======================================================================
switch_user() {

	local hostname="$1"
	local username="$2"

	# si aucun paramètres n'est envoyé à la commande
	if [ -z $username ]; then

		help_switch_user

	# si l'utilisateur rentre n'existe pas 
	elif [ ! -d $ROOT/users/$username ]; then

		echo "Error: can not connect as $username user unknown"

	# sinon
	else

		# selon qu'on soit admin ou utilisateur:
		# > on se connecte en tant que nouvel admin/utilisateur sur la meme machine
		# > puis on ecrit les logs de connexion
		# > puis on gère la nouvelle ligne de commande
		if [ "$username" = "admin" ]; then

			connect "$username" "rvsh" && \
			write_logs "$username" "rvsh" "connected" && \
        	handle_admin_cmd 
		
		else
		
			connect "$username" "$hostname" && \
			write_logs "$username" "$hostname" "connected" && \
        	handle_users_cmd "$username" "$hostname" "$(date +%T)"
		
		fi
    
    fi

}


# === END OF FILE =====================================================