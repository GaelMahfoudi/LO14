#===================================================================================
# file         : su.sh
# usage        : ---
#
# description  : fichier source de la commande su.
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


#=== includes ======================================================================

source handle_connections.sh

#=== end includes ================================================================== 


# repertoire racine de rvsh
ROOT="$HOME/rvsh"


#=== function ======================================================================
# name         : help_switch_user
# description  : affiche l'aide en ligne de la commande `switch_user'
# 
# parameters   : ---
#===================================================================================
help_switch_user() {

	echo "usage: su <user>"
	echo ""

}

#=== function ======================================================================
# name         : switch_user
# description  : permet de changer d'utilisateur
#
# parameters   :
# $1 - le nom du nouvel utilisateur
# $2 - le nom de la machine courante
#===================================================================================
switch_user() {

	local hostname="$1"
	local username="$2"


	# si aucun paramètres n'est envoyé à la commande
	if [ -z $username ]; then

		help_switch_user

	# si l'utilisateur entré n'existe pas
	elif [ ! -d $ROOT/users/$username ]; then

		echo "Error: can not connect as $username user unknown"

	# sinon
	else

		connect "$username" "$hostname" && \						# on se connecte en tant que nouvel utilisateur sur la meme machine
        write_logs "$username" "$hostname" "connected" && \			# puis on ecrit les logs de connexion
        handle_users_cmd "$username" "$hostname" "$(date +%T)"		# puis on gère la nouvelle ligne de commande
    
    fi
}