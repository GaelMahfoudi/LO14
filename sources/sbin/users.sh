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

change_name() {
    
    local userpath="home/rvsh/user/"
    local username=$1
    local newname=""
    
    while [ "$newname" = "" ]
    do
        read -p "Enter the new name for $username: " newname
    done
    
    
    
    mkdir $userpath$new
    cp -r $userpath$old/* $userpath$new
    rm -r $userpath$old
    
}

add_access_host() {

    local userpath="home/rvsh/user/"
    local newhost=$1
    echo -e "$1\n" >> $userpath/hostlist

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
    
    getopts "a:r:p:n:m:lh" OPTION
    
    case "$OPTION" in
        "a" ) add_user $OPTARG;;
        "r" ) del_user $OPTARG;;
        "p" ) change_password $OPTARG;;
        "n" ) change_name $OPTARG;;
        "l" ) user_list;;
        "h" ) help_users;;
    esac
}
