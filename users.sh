# =====================================================================
#
#           FILE : users.sh
#
#          USAGE : ---
#
#    DESCRIPTION : fichier source de la commande user.
#
#
#         OPTION : voir la fonction help_users
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# ==== FUNCTION =======================================================
#
#        NAME : user_list
# DESCRIPTION : Liste des utilisateurs existants ainsi que leurs 
#               accès aux machines.
# PARAMETER   : Pas de paramètre.
#
# =====================================================================
user_list() {
    
    list=$(ls $ROOT/users/)
    array_list=($list) # on recupere les utilisateurs sous forme d'un tableaux

    # pour chaque utilisateurs du tableau
    for usr in ${array_list[@]}; do

        # on suppose qu'il n'est pas utile de lister
        # l'invité ou l'admin.
        [ "$usr" = "admin" ] || [ "$usr" = "guest" ] && continue
        

        # on recupere le contenu du fichier hostlist
        # sous forme d'un tableau
        # i.e chaque machines est un element du tableau access
        access=($(cat $ROOT/users/$usr/hostlist))


        # si il est vide: affichage particulier
        if [ ${#access[@]} -eq 0 ]; then
            printf "%-15s (access host: empty)\n" "$usr"  
        
        # sinon on affiche la liste des machines auxquelles
        # l'utilisateur à accès.
        else

            # "hack" pour affichage "m1, m2, m3"
            tmp=$(printf ",%s" "${access[@]}")
            access_str=${tmp:1}
            printf "%-15s (access host: %s)\n" "$usr" "$access_str"
        
        fi
        
    done
}


# ==== FUNCTION =======================================================
#
#        NAME : add_user
# DESCRIPTION : Ajoute un utilisateur.
# PARAMETER $1: Nom du nouvel utilisateur.
#
# =====================================================================
add_user() {

    # si l'utilisateur qu'on désire ajouter n'existe pas
    if [ ! -d $ROOT/users/$1 ]
    then 

        # on cree le dossier de l'utilisateur
        # ainsi que les fichiers 'password' & 'hostlist'
        # associés
        mkdir $ROOT/users/$1
        echo -e "The user $1 has been added."
        touch $ROOT/users/$1/password
        touch $ROOT/users/$1/hostlist
        touch $ROOT/users/$1/mails
        touch $ROOT/users/$1/phones
    
    # sinon on le signal
    else
    
        echo -e "The user $1 already exist."
    
    fi
}


# ==== FUNCTION =======================================================
#
#        NAME : del_user
# DESCRIPTION : Supprime un utilisateur existant.
# PARAMETER $1: Nom de l'utilisateur à supprimer.
#
# =====================================================================
del_user() {

    # si l'utilisateur n'est pas l'admin (on ne peut pas supprimer l'admin)
    if [ ! "$1" = "admin" ]; then

        # dans le cas ou l'utilisateur à supprimer existe
        if [ -d $ROOT/users/$1 ]; then 
            
            # on supprime son dossier personnel sans users
            rm -r $ROOT/users/$1
            echo -e "The user $1 has been removed."

            host_list=$(ls $ROOT/host)

            # pour chacune des machines
            for hst in $host_list; do
                
                # si l'utilisateur à un repertoire personnel
                # au sein de la machine
                # on le supprime
                if [ -d $ROOT/host/$hst/$1 ]; then
                
                    rm -r $ROOT/host/$hst/$1
                
                fi

            done

        # si l'utilisateur n'existe pas, on le précise
        else
        
            echo -e "The user $1 doesn't exist."
        
        fi

    # on ne peut pas supprimer l'admin
    else

        echo "You can't remove the administrator"
    
    fi

}


# ====  CHANGE_PASSWORD  ==============================================
#
#        NAME : change_password
# DESCRIPTION : Change le mot de passe de l'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
#
# =====================================================================
change_password() {

    local pass=""
    
    # l'utilisateur existe
    if [ -d $ROOT/users/$1 ]
    then

        # on demande a l'admin d'entrer le nouveau mot de passe
        # de l'utilisateur
        read -p "(password) Enter the new password for $1 : " -s pass
        echo ""
        
        # si il est vide on quitte la fonction
        if [ -z "$pass" ]; then
            echo "(password) password unchanged for $1"
            return
        fi

        # sinon on reccrit le fichier password de l'utilisateur
        # avec son nouveau mot de passe
        echo "$pass" | md5sum | cut -d ' ' -f1 > $ROOT/users/$1/password

    # si l'utilisateur n'existe pas on le précise
    else

        echo "User $1 does not exists"

    fi
}


# ==== FUNCTION =======================================================
#
#        NAME : change_name
# DESCRIPTION : Change le nom d'utilisateur.
# PARAMETER $1: L'utilisateur à modifier.
#
# =====================================================================
change_name() {
    
    # si l'utilisateur n'est pas l'admin
    if [ ! "$1" = "admin" ]; then

        # si l'utilisateur existe
        if [ -d $ROOT/users/$1 ]; then

            local username=$1
            local newname=""
        
            # on lui demande d'entrée le nouveau nom de l'utilisateur
            read -p "(new name) for $username: " newname

            
            # si le nouveau nom est vide ou inchangé,
            # on quitte la fonction
            if [ "$newname" = "$username" ] || [ -z "$newname" ]; then
                
                echo "(new name) name unchanged for $username"
                return
            
            fi


            # sinon on cree le nouveau repertoire de l'utilisateur
            # dans users
            # on recupere ses anciennes données qu'on copie dans le
            # nouveau repertoire
            # on supprime l'ancien
            mkdir $ROOT/users/$newname
            cp -r $ROOT/users/$username/* $ROOT/users/$newname
            rm -r $ROOT/users/$username 
        
        # si l'utilisateur n'existe pas
        # on le precise
        else

            echo "User $1 does not exist"
        
        fi

    # on ne rennome pas l'administrateur
    else
        echo "You can't rename the administrator"
    fi
    
}


# ==== FUNCTION =======================================================
#
#        NAME : grant_host_access
# DESCRIPTION : Ajoute l'accès à la machine spécifiée.
# PARAMETER $1: L'utilisateur qui aura l'accès.
#
# =====================================================================
grant_host_access() {

    local user_to_grant=$1 # utilisateur à qui on attribue une machine

    # si il existe et si ce n'est pas l'admin
    if [ -d $ROOT/users/$user_to_grant ] || [ "$user_to_grant" != "admin" ]; then
        
        # on lui demande d'enter la nouvelle machine
        read -p "(grant access) enter the hostname: " host_to_add

        # si elle n'existe pas ou qu elle est vide, on le notifie
        if [ ! -d $ROOT/host/$host_to_add ] || [ -z $host_to_add ]; then
            echo "(grant access) host $host_to_add does not exist"
            
        else

            # on verifie si l'hotes n'est pas encore dans le fichier
            if $(grep $host_to_add $ROOT/users/$user_to_grant/hostlist > /dev/null); then

                echo "(grant access) $host_to_add already added."
            
            # si ce n'est pas le cas
            else
                
                # on ajoute le machine à la liste personnelle de
                # l'utilisateur
                # puis on cree un dossier personnel à l'utilisateur
                # dans la machine 
                echo "$host_to_add" >> $ROOT/users/$user_to_grant/hostlist 
                mkdir $ROOT/host/$host_to_add/$user_to_grant
                echo "(grant access) $host_to_add added succesfully."
            fi
        fi

    else
        echo "Can't grant access for $user_to_grant"
    fi

}

# ==== FUNCTION =======================================================
#
#        NAME : revoke_host_access
# DESCRIPTION : retire  à un un utilisateur son accès à
#               une machine.
# PARAMETER $1: L'utilisateur qui n'aura plus l'accès.
#
# =====================================================================
revoke_host_access() {
    
    local user_to_revoke=$1 # utilisateur auquel on va supprimer des droits d'acces

    # si il existe ou si ce n'est pas l'admin
    if [ -d $ROOT/users/$user_to_revoke ] || [ "$user_to_grant" != "admin" ]; then
        
        # on lui demande d'enter la machine a supprimer
        read -p "(revoke access) enter the hostname: " host_to_del

        # si la machine n'existe pas ou qu'elle n'a pas de nom
        if [ ! -d $ROOT/host/$host_to_del ] || [ -z $host_to_del ]; then

            echo "(revoke access) host $host_to_del does not exist"
            
        else

            # on verifie si la machine est  dans le fichier
            if $(grep $host_to_del $ROOT/users/$user_to_revoke/hostlist > /dev/null); then

                # on supprime le dossier de l'utilisateur dans la machine
                # on supprime la ligne de la machine dans le fichier hostlist de l'utilisateur
                # puis on reecrit le contenu du fichier
                rm -r $ROOT/host/$host_to_del/$user_to_revoke  
                file_content=$(cat $ROOT/users/$user_to_revoke/hostlist | sed -e /$host_to_del/d -e s/^$//)
                echo "$file_content" > $ROOT/users/$user_to_revoke/hostlist

                echo "(revoke access) $host_to_del deleted succesfully."

            else

                echo "(revoke access) $host_to_del has not been added yet."

            fi

        fi
        
    # utilisateur n'existe pas
    else

        echo "Can't revoke access for $user_to_revoke"

    fi

}


# ==== FUNCTION =======================================================
#
#        NAME : help_users
# DESCRIPTION : Affiche l'aide de la fonction users.
# PARAMETER   : Pas de paramètre.
#
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
#
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