# dossier racine de rvsh
ROOT="$HOME/rvsh"

change_users_passwd() {

	local username="$1" 	# on recupere l'utilisateur qui veux changer son mot de passe


	# l'utilisateur voulant changer son password existe
	local old_pass="$(cat $ROOT/users/$username/password)"
	local new_pass=""
	local curr_pass=""


	echo "[passwd] Changing password for $username"

	# si l'utilisateur possede un password
	if [ ! -z "$old_pass" ]; then

		read -p "(current) password: " -s curr_pass
		echo ""

		if [ "$(echo "$curr_pass" | md5sum | cut -d' ' -f1 )" != "$old_pass" ]; then
			echo "[passwd] error while entering new password"
			echo "[passwd] password unchanged for $username"
			return
		fi
	fi

	
	# on lui demande son nouveau mot de passe 
	read -p "(new) password: " -s new_pass
	echo ""
	# on update le fichier password de l'utilisateur
	echo "$(echo "$new_pass" | md5sum | cut -d' ' -f1)" > $ROOT/users/$username/password
	echo "[passwd] password updated succesfully for $username"
	
}