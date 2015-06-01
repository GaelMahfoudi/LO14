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



help_switch_user() {

	echo "usage: su <user>"
	echo ""

}

switch_user() {

	# attention à l'inversion
	local hostname="$1"
	local username="$2"


	if [ -z $username ]; then

		# si pas d'argument
		help_switch_user

	elif [ ! -d $ROOT/users/$username ]; then

		# si l'utilisateur n'existe
		echo "Error: can not connect as $username; user unknown"

	else
		connect "$username" "$hostname" && \
        write_logs "$username" "$hostname" "connected" && \
        handle_users_cmd "$username" "$hostname" "$(date +%T)"
    fi
}