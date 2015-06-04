#!/bin/bash 

# =====================================================================
#
#           FILE : afinger.sh
#
#          USAGE : afinger.sh [-tm utilisateurs] [-h]
#
#    DESCRIPTION : Permet à l'utilisateur d'afficher les informations 
#                  complémentaires de l'utilisateur spécifié.
#
#
#         OPTION : voir fonction help_afinger.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================

ROOT="$HOME/rvsh"

# ====  ADD_PHONE  ====================================================
#
#        NAME : add_phone
# DESCRIPTION : Permet d'ajouter/supprimer un tel pour l'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
# =====================================================================

function add_phone {

    if [ ! -e $ROOT/users/$1/phones ]
    then
        touch $ROOT/users/$1/phones
    fi

    phoneList=$(cat $ROOT/users/$1/phones)
    phoneCout=$(($(cat $ROOT/users/$1/phones | wc -l)))

    if [ "$phoneList" = "" ]
    then
    	echo "The user $1 has no phone numbers registered"
    	read -p "Add a new phone : " newPhone
    	echo -en "$newPhone\n" >> $ROOT/users/$1/phones
    else

    	j=1
    	for i in $phoneList
    	do
    		echo "$j) $i"
			j=$(($j+1))
		done

        first="o"
		choice=""
        echo -e "\n"
		while [ ! \( "$choice" = "add" -o "$choice" = "del" \) ]
		do
            echo -en "Would you like to add or del one ? (add/del) : "
            read choice
		done

		if [ "$choice" = "add" ]
		then
			read -p "Add a new phone : " newPhone
			echo -en "$newPhone\n" >> $ROOT/users/$1/phones
		else
			read -p "Which one would you like to remove ? : " phoneToDel
            phoneToDel=${phoneToDel}'d'
            tmp=$(sed $phoneToDel "$ROOT/users/$1/phones")
            rm $ROOT/users/$1/phones

            for k in $tmp
            do
                if [ "$k" != "" ]
                then
                    echo -e "$k" >> $ROOT/users/$1/phones
                fi
            done
		fi
	fi


}


# ====  ADD_MAIL  ====================================================
#
#        NAME : add_mail
# DESCRIPTION : Permet d'ajouter/supprimer un mail pour l'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
# =====================================================================

function add_mail {

    if [ ! -e $ROOT/users/$1/mails ]
    then
        touch $ROOT/users/$1/mails
    fi

    mailList=$(cat $ROOT/users/$1/mails)
    mailCount=$(($(cat $ROOT/users/$1/mails | wc -l)))

    if [ "$mailList" = "" ]
    then
        echo "The user $1 has no mails registered"
        read -p "Add a new mail : " newMail
        echo -en "$newMail\n" >> $ROOT/users/$1/mails
    else

        j=1
        for i in $mailList
        do
            echo "$j) $i"
            j=$(($j+1))
        done

        choice=""
        while [ ! \( "$choice" = "add" -o "$choice" = "del" \) ]
        do
            echo -en "\r                                                                      \r"
            echo -en "Would you like to add or del one ? (add/del) : "
            read choice
        done

        if [ "$choice" = "add" ]
        then
            read -p "Add a new mail : " newMail
            echo -en "$newMail\n" >> $ROOT/users/$1/mails
        else
            read -p "Which one would you like to remove ? : " mailToDel
            mailToDel=${mailToDel}'d'
            tmp=$(sed $mailToDel "$ROOT/users/$1/mails")
            rm $ROOT/users/$1/mails

            for k in $tmp
            do
                if [ "$k" != "" ]
                then
                    echo -e "$k" >> $ROOT/users/$1/mails
                fi
            done
        fi
    fi
}


help_afinger() {

    echo "usage: afinger [-mth]"
    echo ""
    echo "  -h        show this help and quit"
    echo "  -m  <user>  Add or Del an email for the user specified"
    echo "  -t  <user>  Add or Del a phone number for the user specified"
    echo ""


}

# ====  AFINGER  ======================================================
#
#        NAME : afinger
# DESCRIPTION : Effectue le parsage des arguments et appelle les
#               fonctions appropriées.
# PARAMETER $1: Liste des arguments
# =====================================================================

function afinger  {
    

    if [ "$1" = "" ]
    then
        help_afinger
        return
    fi
    
    local OPTIND
    getopts "m:t:h" OPTION
    
    case $OPTION in
        "m" ) add_mail $OPTARG;;
        "t" ) add_phone $OPTARG;;
        "h" ) help_afinger;;
        "" ) help_afinger;;
    esac
}
