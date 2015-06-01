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


push_user_connexion() {

    local username="$1"
    local hostname="$2"

    if [ "$username" != "admin" ]; then
        touch $ROOT/host/$hostname/$username.tmp
        echo "$username,$(date +%T),$(date +%D)" >> $ROOT/host/$hostname/$username.tmp
    fi
}


pop_user_connexion() {

    local username="$1"
    local hostname="$2"
    local ctime="$3"

    new_content=$(cat $ROOT/host/$hostname/$username.tmp | sed /$ctime/d)

    if [ -s $new_content ]; then
        rm $ROOT/host/$hostname/$username.tmp
    else
        echo "$new_content" > $ROOT/host/$hostname/$username.tmp
    fi
}


connect() {
    
    local username="$1"
    local hostname="$2"


    if [ "$username" = "admin" ]; then

        # connexion de l'administrateur
        authentification "$username"

    elif [ -d "$ROOT/users/$username" -a -d "$ROOT/host/$hostname" ]; then

        # connexion si la machine et l'utilisateur existe

        # verification des droits d acces
        cat $ROOT/users/$username/hostlist | grep "$hostname"

        if [ $? -eq 0 ]; then
            authentification "$username"
        else
            echo "You can not connect $username on $hostname: permission denied"
            return 1
        fi

    else

        # probleme de connexion

        echo "[*] connexion refused: bad username or hostname..."
        return 1

    fi


    if [ $? -eq 0 ]; then
        
        echo -e "[*] you are now logged as $username on $hostname."
        push_user_connexion $username $hostname
        return 0

    else

        echo -e "\n[*] connexion refused to $username on $hostname: bad password."
        return 1
    fi
}


disconnect() {

    local username="$1"
    local hostname="$2"
    local ctime="$3"

    if [ "$username" != "admin" ]; then

        pop_user_connexion $username $hostname $ctime
    
    fi
    
    write_logs "$username" "$hostname" "disconnected"

}
