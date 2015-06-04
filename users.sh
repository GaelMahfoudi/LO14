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
# DESCRIPTION : Liste des utilisateurs existants.
# PARAMETER   : Pas de paramètre.
# =====================================================================

user_list() {
    
    list=$(ls $ROOT/users/)
    if [ -z "$list" ]; then
        echo "No users created"
    else
        echo "$list"
    fi
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

    if [ ! "$1" = "admin" ]
    then
        local newhost=""
    
        while [ "$newhost" = "" ]
        do
            read -p "Enter the new accessible host for $1: " newhost
        done
    
        echo -e "$newhost\n" >> $ROOT/users/$1/hostlist
        mkdir $ROOT/host/$newhost/$1
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
