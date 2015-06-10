#======================================================================
# file         : handle_connections.sh
# usage        : ---
#
# description  : fichier source permettant de gerer:
#                 - les connexions/deconnexions des utilisateurs
#                 - l'authentification des utilisateurs
#                 - l'ecriture des logs
#                 - la gestion des fichiers de connexions
#
# options      : ---
# authors      : G. MAHFOUDI & S. JUHEL
# company      : UTT
# version      : 1.0
# bugs         : ---
# notes        : ---
# created      : ---
# revision     : ---
#======================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === FUNCTION ========================================================
#
# name         : authentification
# description  : gere l'authentification des utilisateurs 
#                i.e demande de mot de passe lors de la connexion
# 
# parameters   :
# $1 - le nom de l'utilisateur qui se connecte
#
# returns      :
# 0 - connexion autorisée
# 1 - connexion refusée 
#
# =====================================================================
authentification() {

    local username="$1"                                     # nom utilisateur
    local userpass="$(cat $ROOT/users/$username/password)"  # son mot de passe (md5)

    # si l'utilisateur a un password
    if [ -n "$userpass" ]; then
        
        # on demande le mot de passe de l'utilisateur
        read -p "(connection) password for $username : " -s pass
        echo ""

        # si il entre le mauvais mdp
        # on quitte la fonction en mode erreur.
        [ ! "$(echo "$pass" | md5sum | cut -d' ' -f1 )" = "$userpass" ] && return 1 || return 0

    # si l'utilisateur n'a pas de mdp, on lui autorise la connexion
    else
        return 0
    fi
}


# === FUNCTION ========================================================
#
# name         : write_logs
# description  : fonction de journalisation des connexions au seins
#                du réseau virtuel
# parameters   :
# $1 - le nom de l'utilisateur qui se connecte/deconnecte
# $2 - sa machine virtuelle
# $3 - le message associé au log ('connected' || 'disconnected')
#
# returns      :
# 0 - connexion autorisée
# 1 - connexion refusée
# 
# =====================================================================
write_logs() {

    local username="$1"     # nom de l'utilisateur
    local hostname="$2"     # nom de la machine
    local message="$3"      # le message


    local rep_log=$(date +%F)   # nom du dossier de log (correspond à la date du jour)

    # prompt du log; format:
    # lun 1 juin 2015 -- 08:52:23 >
    local prompt_log=$(date | awk '{printf "%s %s %s %s %s",  substr($1,0, 4), $2, $3, $4, $5}' | sed 's/,/ --/')
    

    # si le dossier de log n'existe pas, on le cree
    if [ ! -d $ROOT/sys/logs/$rep_log ]
    then
        mkdir -p $ROOT/sys/logs/$rep_log
    fi
    
    # on ajoute les informations requises (user, host, connected | disconnected)
    # en fin du fichier syslogs
    echo -e "$prompt_log >  $username @ $hostname: $message" >> $ROOT/sys/logs/$rep_log/systemlogs
} 


# === FUNCTION ========================================================
#
# name         : push_user_connexion
# description  : permet d'ajouter une connexion utilisateur a une machine.
#                cette connexion se situe dans la machine dans un fichier
#                'username'.tmp et contient les données suivantes
#                 >> nom_utilisateur,heure,date   
#                
# parameters   :
# $1 - le nom de l'utilisateur qui se connecte
# $2 - la machine de l'utilisateur
#
# =====================================================================
push_user_connexion() {

    local username="$1"
    local hostname="$2"

    # on n'enregistre pas les connexions admin
    if [ "$username" != "admin" ]; then
        
        # on cree le fichier username.tmp
        # ou juste modifie la date d'acces
        touch $ROOT/host/$hostname/$username.tmp

        # on ajoute les données au fichier
        echo "$username,$(date +%T),$(date +%D)" >> $ROOT/host/$hostname/$username.tmp
    fi
}


# === FUNCTION ========================================================
#
# name         : pop_user_connexion
# description  : permet de mettre a jour le fichier de connexion utilisateur 
#                a une machine.
#                
# parameters   :
# $1 - le nom de l'utilisateur qui se connecte
# $2 - la machine de l'utilisateur
# $3 - l'heure de la connexion
#
# =====================================================================
pop_user_connexion() {

    local username="$1"
    local hostname="$2"
    local ctime="$3"        # heure de connexion de l'utilisateur

    # supprime la ligne de connexion de l'utilisteur
    # sur la machine à l'aide de sa connexion
    new_content=$(cat $ROOT/host/$hostname/$username.tmp | sed /$ctime/d)

    if [ -z "$new_content" ]; then

        # si il n'y a plus de lignes de connexions dans le fichier
        # on le supprime
        rm $ROOT/host/$hostname/$username.tmp
    
    else

        # sinon on reecrit le contenu du nouveau fichier
        # dans le fichier de connexion
        echo "$new_content" > $ROOT/host/$hostname/$username.tmp
    fi
}


#=== FUNCTION =========================================================
#
# name         : connect
# description  : gere la connexion d'un utilisateur à une machine.
#                
# parameters   :
# $1 - le nom de l'utilisateur
# $2 - la machine de l'utilisateur
#
# returns      :
# 1 - connexion refusée
#
#======================================================================
connect() {
    
    local username="$1"
    local hostname="$2"


    if [ "$username" = "admin" ]; then

        # si l'utilisateur qui se connecte est l'administrateur
        # on l'authentifie directement
        authentification "$username"

    elif [ -d "$ROOT/users/$username" -a -d "$ROOT/host/$hostname" ]; then

        # si l'utilisateur existe ainsi que la machine
        

        # verification des droits d acces de l'utilisateur pour se connecter à
        # la machine
        cat $ROOT/users/$username/hostlist | grep "$hostname" 2> /dev/null

        if [ $? -eq 0 ]; then

            # si il a l'accès on l'authentifie
            authentification "$username"

        else

            # sinon on affiche un message d'erreur et on quitte la fonction
            echo "You can not connect $username on $hostname: permission denied"
            return 1

        fi

    else

        # si le nom d'utilisateur ou de machine n'existe pas
        # on quitte 
        echo "Connexion refused: bad username or hostname..."
        return 1

    fi


    # partie executée après l'appel de fonction 
    # authentification
    if [ $? -eq 0 ]; then
        
        # si l'authentification a reussie
        # on affiche la connexion
        # et on update le fichier de connexion dans la machine
        echo -e "(connection) You are now logged as $username on $hostname."
        push_user_connexion $username $hostname
        return 0

    else

        # sinon on affiche un message d'erreur
        echo -e "(connection) Connexion refused to $username on $hostname: bad password."
        return 1

    fi
}


# === FUNCTION ========================================================
#
# name         : disconnect
# description  : gere la deconnexion d'un utilisateur à une machine.
#                
# parameters   :
# $1 - le nom de l'utilisateur
# $2 - la machine de l'utilisateur
# $3 - l'heure de connexion de l'utilisateur 
#
# =====================================================================
disconnect() {

    local username="$1"
    local hostname="$2"
    local ctime="$3"

    
    if [ "$username" != "admin" ]; then

        # si l'utilisateur n'est pas l'admin
        # on retire la connexion
        pop_user_connexion $username $hostname $ctime
    
    fi
    
    # on ecrit les logs de deconnexion
    write_logs "$username" "$hostname" "disconnected"

}

# === END OF FILE =====================================================