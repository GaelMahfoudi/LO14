ROOT="$HOME/rvsh"

authentification() {

    local username="$1"
    local userpass="$(cat $ROOT/users/$username/password)"

    if [ -n "$userpass" ]; then
            
        # si l'utilisateur a un password
        read -p "[CONNECTION] password for $username : " -s pass
        echo ""
        [ ! "$(echo "$pass" | md5sum | cut -d' ' -f1 )" = "$userpass" ] && return 1 || return 0

    else
        return 0
    fi
}

write_logs() {

    local username="$1"
    local hostname="$2"
    local message="$3"

    local rep_log=$(date +%F) # nom du dossier de log
    local prompt_log=$(date | awk '{printf "%s %s %s %s %s",  substr($1,0, 4), $2, $3, $4, $5}' | sed 's/,/ --/')
    

    # si le dossier de log n'existe pas, on le cree
    if [ ! -d $ROOT/.logs/$rep_log ]
    then
        mkdir -p $ROOT/.logs/$rep_log
    fi
    
    echo -e "$prompt_log >  $username @ $hostname: $message" >> $ROOT/.logs/$rep_log/syslogs
} 


connect() {
    
    local username="$1"
    local hostname="$2"
    

    if [ "$username" = "admin" ]; then

        # connexion de l'administrateur

        authentification "$username"

    elif [ -d "$ROOT/users/$username" -a -d "$ROOT/host/$hostname" ]; then

        # connexion si la machine et l'utilisateur existe

        # verifier les droits d'accès à une machine d'un utilisateur 

        authentification "$username"

    else

        # probleme de connexion

        echo "[*] connexion refused: bad username or hostname..."
        return 1

    fi


    if [ $? -eq 0 ]; then
        
        echo -e "[*] you are now logged as $username on $hostname."
        return 0

    else

        echo -e "\n[*] connexion refused to $username on $hostname: bad password."
        return 1
    fi
}


