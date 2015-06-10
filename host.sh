# =====================================================================
#
#           FILE : host.sh
#
#          USAGE : host.sh [-ar machine] [-lh]
#
#    DESCRIPTION : Permet à l'administrateur d'ajouter et de supprimer
#                  des machines.
#
#
#         OPTION : voir fonction help_host.
#         AUTHOR : Gaël Mahfoudi & Simon Juhel
#
# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# ==== FUNCTION =======================================================
#
#        NAME : host_list
# DESCRIPTION : Liste des machines existantes.
# PARAMETER   : Pas de paramètre.
#
# =====================================================================
host_list() {
    
    # on récupère la liste des machines dans liste    
    list=$(ls $ROOT/host/)

    # on affiche si elle est vide
    # si elle ne l'est pas on affiche son contenu
    if [ -z "$list" ]; then
        echo "No host created"
    else
        echo "$list"
    fi
}


# ==== FUNCTION =======================================================
#
#        NAME : add_host
# DESCRIPTION : Ajoute une machine.
# PARAMETER $1: Nom de la nouvelle machine.
#
# =====================================================================
add_host() {

    # si la machine n'existe pas, on la crée
    if [ ! -d $ROOT/host/$1 ]; then 
        mkdir $ROOT/host/$1
        echo -e "The host $1 has been added."

    # sinon on indique qu'elle existe déja
    else
        echo -e "The host $1 already exist."
    fi

}


# ==== FUNCTION =======================================================
#
#        NAME : del_host
# DESCRIPTION : Supprime une machine existant.
# PARAMETER $1: Nom de la machine à supprimer.
#
# =====================================================================
del_host() {

    # si la machine existe
    if [ -d $ROOT/host/$1 ]; then 
        
        # on supprime le dossier addocié à la machi,e
        rm -r $ROOT/host/$1
        echo -e "The host $1 has been removed."

        # On va modifier l'ensemble des fichier hostlist 
        # des utilisateurs afin qu'ils n'aient plus accès 
        # a la machine supprimée
        
        # on recupère la liste des utilisateurs
        userlist=$(ls $ROOT/users/)

        # on parcours tout les utilisateurs
        for usr in $userlist; do

            # on saute le cas ou c'est l'admin car il n'a pas de hostlist
            [ "$usr" = "admin" ] && continue

            # si les utilisateurs ont un accès à la machine supprimé
            # on supprime la ligne correspondante  dans hostlist
            if $(grep $1 $ROOT/users/$usr/hostlist > /dev/null); then
     
                new_hostlist=$(cat $ROOT/users/$usr/hostlist | sed -e /$1/d -e s/^$//)
                echo "$new_hostlist" > $ROOT/users/$usr/hostlist
     
            fi
            
        done

    # si la machine n'existe pas on l'indique
    else
        
        echo -e "The host $1 doesn't exist."
    
    fi
}


# ==== FUNCTION  ======================================================
#
#        NAME : help_host
# DESCRIPTION : Affiche l'aide de la fonction host.
# PARAMETER   : Pas de paramètre.
#
# =====================================================================
help_host() {

    echo "usage: host [-arlh]"
    echo ""
    echo "  -h        show this help and quit"
    echo "  -l        list all VM"
    echo "  -a  <vm>  add a VM"
    echo "  -r  <vm>  remove a VM"
    echo ""
}


# ==== FUNCTION =======================================================
#
#        NAME : host
# DESCRIPTION : Effectue le parsage des arguments et appelle les
#               fonctions appropriées.
# PARAMETER $1: Liste de arguments.
#
# =====================================================================
host() {
   
    if [ ! -d $ROOT/host ]; then 
        mkdir $ROOT/host
    fi

    # on parcours la ligne de commande 
    # pour recuperer les options
    local OPTIND
    
    getopts "a:r:lh" opt

    case "$opt" in
        "a" ) add_host $OPTARG;;
        "r" ) del_host $OPTARG;;
        "l" ) host_list;;
        "h" ) help_host;;
         *) help_host;;
    esac
}
