# =====================================================================
#
#           FILE : finger.sh
#
#          USAGE : finger.sh [utilisateurs] [-h]
#
#    DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#				   complémentaires de l'utilisateur spécifié.
#
#
#         OPTION : voir fonction help_finger.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === FUNCTION ========================================================
#
#        name: help_finger
# description: affiche l'aide en ligne de la commande 'finger'
# 
#  parameters: ---
#
# =====================================================================
help_finger() {

    echo "usage: finger [-h] <user>"
    echo ""
    echo "  -h      show this help and quit"
    echo "  <user>  show this user info" 
    echo ""
}


# ==== FUNCTION =======================================================
#
#        NAME : finger
# DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#				complémentaires de l'utilisateur spécifié.
# PARAMETER $1: L'utilisateur spécifié.
#
# =====================================================================
finger() {


	local userhost="$1"

	# si le nom de l'utilisateur est vide ou si l'option help est active
	if [ -z "$1" ] || [ "$1" = "-h" ]; then
        
        help_finger
        return
    
    # cas ou l'utilisateur n'existe pas
    elif [ ! -d $ROOT/users/$1 ]; then

    	echo "User $1 does not exist"

    # sinon on affiche sa liste d'email et de telephone
	else    
		
		mail_list=$(cat $ROOT/users/$1/mails)
		phone_list=$(cat $ROOT/users/$1/phones)
	

		printf "%-12s %-8s\n" "User" "TTY" "%" 
		printf "%-12s %-8s\n\n" "$1"  "$(tty | cut -d'/' -f3-)" 

		printf "Mails:\n"
		echo "$mail_list"

		printf "Phones:\n"
		echo "$phone_list"

	fi
}