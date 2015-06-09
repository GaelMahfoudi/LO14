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

            hostL=$(ls $ROOT/host)

            for i in $hostL
            do
                if [ -d $ROOT/host/$i/$1 ]
                then
                    rm -r $ROOT/host/$i/$1
                fi
            done

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

        read -p "(password) Enter the new password for $1 : " -s pass
        echo ""
        
        if [ -z "$pass" ]; then
            echo "(password) password unchanged for $1"
            return
        fi

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
        
            read -p "(new name) for $username: " newname

            
            if [ "$newname" = "$username" ] || [ -z "$newname" ]; then
                echo "(new name) name unchanged for $username"
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
grant_host_access() {

    local user_to_grant=$1

    if [ -d $ROOT/users/$user_to_grant ] || [ "$user_to_grant" = "admin" ]; then
        
        read -p "(grant access) enter the hostname: " host_to_add

        if [ ! -d $ROOT/host/$host_to_add ] || [ -z $host_to_add ]; then
            echo "(grant access) host $host_to_add does not exist"
            
        else

            # on verifie si l'hotes n'est pas encore dans le fichier

            if $(grep $host_to_add $ROOT/users/$user_to_grant/hostlist > /dev/null); then
                echo "(grant access) $host_to_add already added."
            else
                echo "$host_to_add" >> $ROOT/users/$user_to_grant/hostlist 
                mkdir $ROOT/host/$host_to_add/$user_to_grant
                echo "(grant access) $host_to_add added succesfully."
                mkdir $ROOT/host/$host_to_add/$user_to_grant/
            fi
        fi

    else
        echo "Can't grant access for $user_to_grant"
    fi

}

revoke_host_access() {
    
    local user_to_revoke=$1

    if [ -d $ROOT/users/$user_to_revoke ] || [ "$user_to_grant" = "admin" ]; then
        
        read -p "(revoke access) enter the hostname: " host_to_del

        if [ ! -d $ROOT/host/$host_to_del ] || [ -z $host_to_del ]; then
            echo "(revoke access) host $host_to_del does not exist"
            
        else

            # on verifie si l'hotes n'est pas encore dans le fichier

            if $(grep $host_to_del $ROOT/users/$user_to_revoke/hostlist > /dev/null); then

                rm -r $ROOT/host/$host_to_add/$user_to_revoke  
                file_content=$(cat $ROOT/users/$user_to_revoke/hostlist | sed -e /$host_to_del/d -e s/^$//)
                echo "$file_content" > $ROOT/users/$user_to_revoke/hostlist

                echo "(revoke access) $host_to_del deleted succesfully."

            else
                echo "(revoke access) $host_to_del has not been added yet."
            fi
        fi

    else
        echo "Can't revoke access for $user_to_revoke"
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
    echo "  -d <usr>   delete user"
    echo "  -p <usr>   change user password"
    echo "  -n <usr>   change user name"
    echo "  -g <usr>   grant user access to host"
    echo "  -r <usr>   revoke user access to host"
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
    
    getopts "a:d:p:n:g:r:m:lh" OPTION
    
    case "$OPTION" in
        "a" ) add_user $OPTARG;;
        "d" ) del_user $OPTARG;;
        "p" ) change_password $OPTARG;;
        "n" ) change_name $OPTARG;;
        "g" ) grant_host_access $OPTARG;;
        "r" ) revoke_host_access $OPTARG;;
        "l" ) user_list;;
        "h" ) help_users;;
        * ) help_users;;
    esac
}