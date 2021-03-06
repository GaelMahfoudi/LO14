#!/bin/bash 

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
# =====================================================================




# chemin d'accès à la racine de rvsh
ROOT="$HOME/rvsh"


# ====  HOST_LIST  ====================================================
#
#        NAME : host_list
# DESCRIPTION : Liste des machines existants.
# PARAMETER   : Pas de paramètre.
# =====================================================================

host_list() {
    
    list=$(ls $ROOT/host/)
    if [ -z "$list" ]; then
        echo "No VMs created"
    else
        echo "$list"
    fi
}


# ====  ADD_HOST  =====================================================
#
#        NAME : add_host
# DESCRIPTION : Ajoute une machine.
# PARAMETER $1: Nom de la nouvelle machine.
# =====================================================================

add_host() {

    if [ ! -d $ROOT/host/$1 ]; then 
        mkdir $ROOT/host/$1
        echo -e "The host $1 has been added."
    else
        echo -e "The host $1 already exist."
    fi

}


# ====  DEL_HOST  =====================================================
#
#        NAME : del_host
# DESCRIPTION : Supprime une machine existant.
# PARAMETER $1: Nom de la machine à supprimer.
# =====================================================================

del_host() {
    if [ -d $ROOT/host/$1 ]; then 
        rmdir $ROOT/host/$1
        echo -e "The host $1 has been removed."
    else
        echo -e "The host $1 doesn't exist."
    fi
}


# ====  HELP_HOST  ====================================================
#
#        NAME : help_host
# DESCRIPTION : Affiche l'aide de la fonction host.
# PARAMETER   : Pas de paramètre.
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


# ====  HOST  =========================================================
#
#        NAME : host
# DESCRIPTION : Effectue le parsage des arguments et appelle les
#               fonctions appropriées.
# PARAMETER $1: Liste de arguments.
# =====================================================================

host() {
    
    if [ ! -d $ROOT/host ]; then 
        mkdir $ROOT/host
    fi
    
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
