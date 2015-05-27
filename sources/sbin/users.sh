function user-list {
    echo -e -n "$White"
    echo -e -n $(ls /home/rvsh/user)
    echo -e "$NC"
}

function add-user {

    if [ ! -d /home/rvsh/user/$1 ]
    then 
        mkdir /home/rvsh/user/$1
        echo -e "${White}The user $1 has been added.$NC"
    else
        echo -e "${White}The user $1 already exist.$NC"
    fi
}

function del-user {

    
    if [ -d /home/rvsh/user/$1 ]
    then 
        rmdir /home/rvsh/user/$1
        echo -e "${White}The user $1 has been removed.$NC"
    else
        echo -e "${White}The user $1 doesn't exist.$NC"
    fi

}

function change_password {

    local pass=""
    
    while [ "$pass" = "" ]
    do
        read -p "Enter the new password for $1 : " pass
    done
    
    echo "$pass" | md5sum | cut -d ' ' -f1 > /home/rvsh/user/$1/password

}

function user {

    if [ ! -d /home/rvsh/user ]
    then 
        mkdir /home/rvsh/user
    fi
    
    local OPTIND
    
    getopts "a:r:p:lh" OPTION
    
    
    case "$OPTION" in
        "a" ) add-user $OPTARG;;
        "r" ) del-user $OPTARG;;
        "p" ) change_password $OPTARG;;
        "l" ) user-list;;
        "h" ) echo "aide";;
    esac
}
