# =====================================================================
#
#			FILE : write.sh
#
#		   USAGE : write.sh [utilisateur@vm] [Message à envoyer]
#
#	 DESCRIPTION : Envoi un message à l'utilisateur spécifié.
#
#
#		  OPTION : voir la fonction help_write
#		  AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# ====  WRITE  ========================================================
#
#		 NAME : write
# DESCRIPTION : Envoi un message à l'utilisateur spécifié.
# PARAMETER $1: Chaine de caractère ou le premier mot est 
#				"utilisateur@vm" puis le reste est le message à envoyer
#			$2: Nom de l'utilisateur qui envoie le message.
# =====================================================================
write() {

	cible=($1)
	cible=${cible[0]}

	msg=${1:$((${#cible[0]}+1))}

	cible=$(echo $cible | awk -F "@" '{print $1}')
	

	if [ ! -d $ROOT/users/$cible/msg/ ]
	then
		mkdir $ROOT/users/$cible/msg/
	fi
	
	sender="$2.$(date +%H%M%N)"
	echo -e $msg > $ROOT/users/$cible/msg/$sender

}


# === END OF FILE =====================================================