#!/bin/bash
# =====================================================================
#
#           FILE : users.sh
#
#          USAGE : users.sh [-arpnm user] [-lh]
#
#    DESCRIPTION : Permet à l'administrater de gérer les informations 
#                  des utilisateurs.
#
#
#         OPTION : voir la fonction help_users
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================


# chemin d'accès à la racine de rvsh
ROOT="$HOME/rvsh"


# ====  USER_LIST  ====================================================
#
#        NAME : user_list
# DESCRIPTION : Liste des utilisateurs existants ainsi que leurs 
#               accès aux machines.
# PARAMETER   : Pas de paramètre.
# =====================================================================
user_list() {
    
    list=$(ls $ROOT/users/)
    array_list=($list) # on recupere les utilisateurs sous forme d'un tableaux

    for usr in ${array_list[@]}; do

        [ "$usr" = "admin" ] || [ "$usr" = "guest" ] && continue
            
        access=($(cat $ROOT/users/$usr/hostlist))

        if [ ${#access[@]} -eq 0 ]; then
            printf "%-15s (access host: empty)\n" "$usr"  
        else
            tmp=$(printf ",%s" "${access[@]}")
            access_str=${tmp:1}
            printf "%-15s (access host: %s)\n" "$usr" "$access_str"
        fi
        
    done
}


# ====  ADD_USER  =====================================================
#
#        NAME : add_user
# DESCRIPTION : Ajoute un utilisateur.
# PARAMETER $1: Nom du nouvel utilisateur.
# =====================================================================
add_user() {

    if [ ! -d $ROOT/users/$1 ]
    then 
        mkdir $ROOT/users/$1
        echo -e "The user $1 has been added."
        touch $ROOT/users/$1/password
        touch $ROOT/users/$1/hostlist
    else
        echo -e "The user $1 already exist."
    fi
}


# ====  DEL_USER  =====================================================
#
#        NAME : del_user
# DESCRIPTION : Supprime un utilisateur existant.
# PARAMETER $1: Nom de l'utilisateur à supprimer.
# =====================================================================
del_user() {

    if [ ! "$1" = "admin" ]
    then
        if [ -d $ROOT/users/$1 ]
        then 
            rm -r $ROOT/users/$1
            echo -e "The user $1 has been removed."
        else
            echo -e "The user $1 doesn't exist."
        fi
    else
        echo "You can't remove the administrator"
    fi

}


# ====  CHANGE_PASSWORD  ==============================================
#
#        NAME : change_password
# DESCRIPTION : Change le mot de passe de l'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
# =====================================================================
change_password() {

    local pass=""
    
    if [ -d $ROOT/users/$1 ]
    then

        while [ "$pass" = "" ]
        do
            read -p "Enter the new password for $1 : " -s pass
            echo ""
        done
        
        echo "$pass" | md5sum | cut -d ' ' -f1 > $ROOT/users/$1/password

    else

        echo "User $1 does not exists"

    fi
}


# ====  CHANGE_NAME  ==================================================
#
#        NAME : change_name
# DESCRIPTION : Change le nom d'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
# =====================================================================
change_name() {
    
    
    if [ ! "$1" = "admin" ]
    then
        if [ -d $ROOT/users/$1 ]
        then

            local username=$1
        
            local newname=""
        
            while [ "$newname" = "" ]
            do
                read -p "Enter the new name for $username: " newname
            done
        
            
            if [ "$newname" = "$username" ]; then
                return
            fi

            mkdir $ROOT/users/$newname
            cp -r $ROOT/users/$username/* $ROOT/users/$newname
            rm -r $ROOT/users/$username 
        
        else
            echo "User $1 does not exist"
        fi

    else
        echo "You can't rename the administrator"
    fi
    
}


# ====  ADD_ACCESS_HOST  ==============================================
#
#        NAME : add_access_host
# DESCRIPTION : Ajoute l'accès à la machine spécifiée.
# PARAMETER $1: L'utilisateur qui aura l'accès.
# =====================================================================
add_access_host() {

    
    if [ ! -d $ROOT/users/$1 ]; then
        echo "User $1 does not exist"
        return
    fi

    if [ ! -e $ROOT/users/$1/hostlist ]
    then
        touch $ROOT/users/$1/hostlist
    fi

    local hostL=$(cat $ROOT/users/$1/hostlist) 
    local newhost=""

    if [ ! "$1" = "admin" ]
    then

        local newhost=""


        if [ "$hostL" = "" ]
        then
            echo "The user $1 has no host in his list"
            while [ "$newhost" = "" ]
            do
                read -p "Enter the new accessible host for $1: " newhost
                if [ ! -d  $ROOT/host/$newhost ]; then
                    echo "$newhost does not exists."
                    newhost=""
                fi
            done
            echo -e "$newhost\n" >> $ROOT/users/$1/hostlist
            mkdir $ROOT/host/$newhost/$1
        else

            j=1
            for i in $hostL
            do
                echo "$j) $i"
                j=$(($j+1))
            done

            choice=""
            while [ ! \( "$choice" = "add" -o "$choice" = "del"  -o "$choice" = "quit" \) ]
            do
                echo -en "\r                                                                      \r"
                echo -en "Would you like to add or del one ? (add/del/quit) : "
                read choice
            done

            if [ "$choice" = "add" ]
            then
                while [ "$newhost" = "" ]
                do
                    read -p "Enter the new accessible host for $1: " newhost
                    if [ ! -d  $ROOT/host/$newhost ]; then
                        echo "$newhost does not exists."
                        newhost=""
                    fi
                done
                echo -e "$newhost\n" >> $ROOT/users/$1/hostlist
                mkdir $ROOT/host/$newhost/$1
            else
                if [ "$choice" = "del" ]
                then
                    read -p "Which one would you like to remove ? (enter the number) : " hostToDel
                    ind=$(($hostToDel-1))
                    list=($hostL)
                    hostToDel=${hostToDel}'d'
                    tmp=$(sed $hostToDel "$ROOT/users/$1/hostlist")
                    rm $ROOT/users/$1/hostlist
                    touch $ROOT/users/$1/hostlist
                    rm -r $ROOT/host/${list[$ind]}/$1

                    for k in $tmp
                    do
                        if [ "$k" != "" ]
                        then
                            echo -e "$k" >> $ROOT/users/$1/hostlist
                        fi
                    done
                fi
            fi
        fi
    else
        echo "You can't add host to the administrator"
    fi
}


# ====  HELP_USERS  ===================================================
#
#        NAME : help_users
# DESCRIPTION : Affiche l'aide de la fonction users.
# PARAMETER   : Pas de paramètre.
# =====================================================================
help_users() {

    echo "usage: users [-arlh]"
    echo ""
    echo "  -l         list all users"
    echo "  -h         show this help and quit"
    echo "  -a <usr>   add user"
    echo "  -r <usr>   remove user"
    echo "  -p <usr>   change user password"
    echo "  -n <usr>   change user name"
    echo "  -m <usr>   change user access list"
    echo ""
}




# ====  USERS  ========================================================
#
#        NAME : users
# DESCRIPTION : Effectue le parsage des arguments et appelle les
#               fonctions appropriées.
# PARAMETER $1: Liste de arguments.
# =====================================================================
users() {

    local OPTIND
    
    getopts "a:r:p:n:m:lh" OPTION
    
    case "$OPTION" in
        "a" ) add_user $OPTARG;;
        "r" ) del_user $OPTARG;;
        "p" ) change_password $OPTARG;;
        "n" ) change_name $OPTARG;;
        "m" ) add_access_host $OPTARG;;
        "l" ) user_list;;
        "h" ) help_users;;
        * ) help_users;;
    esac
}