# =====================================================================
#
#           FILE : msg.sh
#
#          USAGE : msg.sh
#
#    DESCRIPTION : Fonction utilitaire liée à la messagerie.
#
#
#         OPTION : voir fonction check_msg.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"
YELLOW='\e[0;33m'       # Yellow
NC='\e[0m'       		# Text Reset

# =====================================================================



# ==== PRINT_MSG ======================================================
#
#        NAME : print_msg
# DESCRIPTION : Affiche les messages reçus par l'utilisateurs.
# PARAMETER $1: L'utilisateur dont on veut afficher les messages.
# =====================================================================
print_msg() {

	local msg=""							#Le contenu du message à afficher
	local name=""							#Le nom de la personne qui a envoyé le message

	#On parcoure les fichiers messages pour les afficher
	for i in $(ls $ROOT/users/$1/msg)
	do
		name=$(echo $i | awk -F "." '{print $1}')				#On récupère le nom de l'envoyeur
		echo -en "${YELLOW}Message from $name : $NC"
		msg=$(cat $ROOT/users/$1/msg/$i)						#On récupère le contenu du message
		echo -e "$msg"
		rm $ROOT/users/$1/msg/$i 								#On supprime le message
	done

}

#Vérifie si l'utilisateur a reçu un ou plusieurs messages.
# $1 : Nom de l'utilisateur

# ==== CHECK_MSG ======================================================
#
#        NAME : check_msg
# DESCRIPTION : Vérifie si l'utilisateur a de nouveaux messages.
# PARAMETER $1: L'utilisateur dont on veut vérifier si il a de 
#				de nouveaux messages.
# =====================================================================
check_msg() {

	#On vérifie que le dossier de message existe. Si non on le crée.
	if [ ! -d $ROOT/users/$1/msg/ ]
	then
		mkdir $ROOT/users/$1/msg/
	fi

	local msgList=$(ls $ROOT/users/$1/msg)				#La liste des messages
	local msgCount=($msgList)							#La liste des messages sous forme de tableau

	if [ "$msgList" != "" ]								#Si la liste des messages n'est pas vide
	then
		echo -e "You have $YELLOW${#msgCount[@]}$NC new messages : "		#On affiche le nombre de message reçu
		print_msg $1														#On les affiche
	fi
}

