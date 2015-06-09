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


# === FUNCTION ========================================================
#
#        name: change_users_passwd
# description: permet de changer de mot de passe sur l'ensemble du
#			   réseau virtuel
# 
#  parameters: 
# 	$1 - le nom de l'utilisateur qui désire changer son mot de passe
# =====================================================================
change_users_passwd() {

	local username="$1" 										# utilisateur qui veux changer son mot de passe
	local old_pass="$(cat $ROOT/users/$username/password)" 		# ancien mot de passe de l'utilisateur
	local new_pass=""											# nouveau mot de passe
	local curr_pass=""											# le mot de passe courant de l'utiliateur (pour la verifcation du bon mdp)			


	echo "Changing password for $username"

	# cas où l'utilisateur possède un mot de passe
	if [ ! -z "$old_pass" ]; then

		# on lui demande d'entrer son mot de passe actuel
		read -p "(current) password: " -s curr_pass
		echo ""

		# si le mot de passe entre est different 
		# de celui qu'il possède on quitte la fonction
		if [ "$(echo "$curr_pass" | md5sum | cut -d' ' -f1 )" != "$old_pass" ]; then
			echo "Error while entering new password"
			echo "Password unchanged for $username"
			return
		fi
	fi

	
	# cas où l'utilisateur ne possède pas de mot de passe
	# ou cas où il a saisi le bon mot de passe actuel
	# on lit le nouveau mot de passe 
	read -p "(new) password: " -s new_pass
	echo ""
	
	# on update le fichier password de l'utilisateur
	echo "$(echo "$new_pass" | md5sum | cut -d' ' -f1)" > $ROOT/users/$username/password
	echo "Password updated succesfully for $username"
	
}