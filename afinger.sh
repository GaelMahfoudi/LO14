#!/bin/bash

# Commande afinger, permet de 
# rajouter des informations 
# complémantaires sur l'util-
# isateurs

ROOT="$HOME/rvsh"


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

		choice=""
		while [ ! \( "$choice" = "add" -o "$choice" = "del" \) ]
		do
			echo -en "\r                                                                      \r"
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


# Gère les options passé en paramètre
# $1 : Les options est arguments
function afinger  {
    
    local OPTIND
    getopts "m:t:h" OPTION
    
    case $OPTION in
        "m" ) add_mail $OPTARG;;
        "t" ) add_phone $OPTARG;;
        "h" ) echo "A faire";;
    esac
}
