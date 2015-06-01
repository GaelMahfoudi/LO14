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

    if [ ! "$1" = "admin" ]
    then
        if [ -d $ROOT/users/$1 ]
        then 
            rm -r $ROOT/users/$1
            echo -e "The user $1 has been removed."
        else
            echo -e "The user $1 doesn't exist."
        fi
    else
        echo "You can't remove the administrator"
    fi

}

change_password() {

    local pass=""
    
    if [ -d $ROOT/users/$1 ]
    then

        while [ "$pass" = "" ]
        do
            read -p "Enter the new password for $1 : " -s pass
            echo ""
        done
        
        echo "$pass" | md5sum | cut -d ' ' -f1 > $ROOT/users/$1/password

    else

        echo "User $1 does not exists"

    fi
}

change_name() {
    
    
    if [ ! "$1" = "admin" ]
    then
        if [ -d $ROOT/users/$1 ]
        then

            local username=$1
        
            local newname=""
        
            while [ "$newname" = "" ]
            do
                read -p "Enter the new name for $username: " newname
            done
        
        
            mkdir $ROOT/users/$newname
            cp -r $ROOT/users/$username/* $ROOT/users/$newname
            rm -r $ROOT/users/$username
        else

            echo "User $1 does not exist"

        fi

    else
        echo "You can't rename the administrator"
    fi
    
}

add_access_host() {

    if [ ! "$1" = "admin" ]
    then
        local newhost=""
    
        while [ "$newhost" = "" ]
        do
            read -p "Enter the new accessible host for $1: " newname
        done
    
        echo -e "$newhost\n" >> $ROOT/users/$1/hostlist
    else
        echo "You can't add host to the administrator"
    fi
}

help_users() {

    echo "usage: users [-arlh]"
    echo ""
    echo "  -l         list all users"
    echo "  -h         show this help and quit"
    echo "  -a <usr>   add user"
    echo "  -r <usr>   remove user"
    echo "  -p <usr>   change user password"
    echo "  -n <usr>   change user name"
    echo "  -m <usr>   change user access list"
    echo ""
}

#Le best easter egg de notre projet <3

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
