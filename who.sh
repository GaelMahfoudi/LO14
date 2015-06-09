# =====================================================================
#
#           FILE : who.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande who
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
#        name: who_is_connected_on
# description: affiche l'ensemble des utilisateurs connectés à la
#			   machine passée en argument
# 
#  parameters:
#	$1 - nom de la machine
#
# =====================================================================
who_is_connected_on() {

	local hostname="$1"
	
	# si la machine a laquelle on souhaite se connecter
	# n'existe pas
	if [ ! -d $ROOT/host/$hostname ]; then
		echo "Host $hostname does not exist"
	
	# dans le cas ou la machine existe
	else
	
		# on recupère l'ensemble des fichiers de connexion de la
		# machine qu'on stocke dans la variable ret
		ret=$(ls $ROOT/host/$hostname/*.tmp 2> /dev/null)
		
		# si personne n'est connectée
		# on quitte la fonction
		if [ -z "$ret" ]; then

			return
		
		# sinon on va afficher l'ensemble de ses utilisateurs
		# connectée 
		else

			printf "(host) $hostname\n"
			printf "%-12s %-9s %-9s\n" "user" "hour" "date"
			echo   "------------ --------  --------"

			# on lit un à un les fichiers de connexions
			for conn in $ret; do

				# affichage formate des connexions trouvees dans le fichier
				cat $conn | awk -F',' '{printf "%-12s %-9s %-9s\n", $1, $2, $3}'
				
			done
			
		fi

		printf "\n"
	
	fi

}


# === END OF FILE =====================================================