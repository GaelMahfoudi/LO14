# =====================================================================
#
#           FILE : ls.sh
#
#          USAGE : ls [Dossier]
#
#    DESCRIPTION : Permet à l'utilisateur ou l'administrateur d'afficher 
#				   le contenu du répertoire courant ou d'un dossier cible.
#
#
#         OPTION : 
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================



rvsh_ls() {

	local location=$1
	local cible=$2


	if [ "$cible" = "" ]								#Si on a pas précisé de paramètre à ls, on affiche le contenu du répertoire courant
	then
		ls -F $HOME$location
	else
		if [ -d $HOME$location$cible ]					#Si on a précisé un paramètre à ls, on affiche le contenu du répertoire cible.
		then
			ls -F $HOME$location$cible
		else
			echo "$location$cible : No such a directory"
		fi
	fi
	
}
