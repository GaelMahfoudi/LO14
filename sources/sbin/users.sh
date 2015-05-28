# chemin d'accès à la racine de rvsh
ROOT="$HOME/rvsh"

user_list() {
    
    list=$(ls $ROOT/users/)
    if [ -z "$list" ]; then
        echo "No users created"
    else
        echo "$list"
    fi
}

add_user() {

    if [ ! -d $ROOT/users/$1 ]
    then 
        mkdir $ROOT/users/$1
        echo -e "The user $1 has been added."
    else
        echo -e "The user $1 already exist."
    fi
}

del_user() {

    
    if [ -d $ROOT/users/$1 ]
    then 
        rmdir $ROOT/users/$1
        echo -e "The user $1 has been removed."
    else
        echo -e "The user $1 doesn't exist."
    fi

}

change_password() {

    local pass=""
    
    while [ "$pass" = "" ]
    do
        read -p "Enter the new password for $1 : " pass
    done
    
    echo "$pass" | md5sum | cut -d ' ' -f1 > $ROOT/users/$1/password

}

help_users() {

    echo "usage: users [-arlh]"
    echo ""
    echo "  -h    show this help and quit"
    echo "  -a    add user"
    echo "  -r    remove user"
    echo "  -l    list all users"
    echo ""
}

users() {

    local OPTIND
    
    getopts "a:r:c:lh" OPTION
    
    case "$OPTION" in
        "a" ) add_user $OPTARG;;
        "r" ) del_user $OPTARG;;
        "c" ) user_config $OPTARG;;
        "l" ) user_list;;
        "h" ) help_users;;
        * ) help_users;;
    esac
}
