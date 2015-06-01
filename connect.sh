# dossier racine de rvsh
ROOT="$HOME/rvsh"


help_connect() {

    echo "usage: connect <hostname>"
    echo ""

}

connect_to_vm() {

    local username="$1"
    local new_vm="$2"

    if [ -z "$new_vm" ]; then

        help_connect

    else
        connect "$username" "$new_vm" && \
        write_logs "$username" "$new_vm" "connected" &&\
        handle_users_cmd "$username" "$new_vm" "$(date +%T)"
    fi

}