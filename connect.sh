# =====================================================================
#
# file         : connect.sh
# usage        : ---
#
# description  : fichier source de la commande connect.
#
# options      : ---
# authors      : G. MAHFOUDI & S. JUHEL
# company      : UTT
# version      : 1.0
# bugs         : ---
# notes        : ---
# created      : ---
# revision     : ---
#
# =====================================================================


# === INCLUDES ========================================================

source handle_connections.sh

# =====================================================================


# === GLOBAL VARIABLES ================================================

ROOT="$HOME/rvsh"

# =====================================================================


# === function ========================================================
#
# name         : help_connect
# description  : affiche l'aide en ligne de la commande `connect_to_vm'
# 
# parameters   : ---
#
#======================================================================
help_connect() {
    echo "Usage: connect <hostname>"
    echo ""
}


# === function ========================================================
#
# name         : connect
# description  : permet à un utilisateur de se connecter à une 
#                autre machine du réseau virtuel.
# 
# parameters   :
# $1 - le nom de l'utilisateur qui veut se connecter
# $2 - le nom de la nouvelle machine à laquelle il va se connecter
#
# =====================================================================
connect_to_vm() {

    local username="$1"
    local new_vm="$2"

    # si aucune machine n'est précisée
    # on affiche l'aide
    if [ -z "$new_vm" ]; then

        help_connect

    # dans le case ou une machine est précisée
    else

        # on se connecte sur la nouvelle machine
        # puis on ecrit les logs de connexion
        # puis on gère la nouvelle ligne de commande

        connect "$username" "$new_vm" && \
        write_logs "$username" "$new_vm" "connected" && \
        handle_users_cmd "$username" "$new_vm" "$(date +%T)"    
    
    fi

}


# === END OF FILE =====================================================