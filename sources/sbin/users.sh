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
        touch $ROOT/users/$1/password
        touch $ROOT/users/$1/hostlist
    else
        echo -e "The user $1 already exist."
    fi
}

del_user() {

    
    if [ -d $ROOT/users/$1 ]
    then 
        rm -r $ROOT/users/$1
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
    
    local username=$1
    
    local newname=""
    
    while [ "$newname" = "" ]
    do
        read -p "Enter the new name for $username: " newname
    done
    
    
    
    mkdir $ROOT/users/$newname
    cp -r $ROOT/users/$username/* $ROOT/users/$newname
    rm -r $ROOT/users/$username
    
}

add_access_host() {

    
    local newhost=""
    
    while [ "$newhost" = "" ]
    do
        read -p "Enter the new accessible host for $1: " newname
    done
    
    echo -e "$newhost\n" >> $ROOT/users/$1/hostlist

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
        "m" ) add_access_host $OPTARG;;
        "l" ) user_list;;
        "h" ) help_users;;
        * ) help_users;;
    esac
}
