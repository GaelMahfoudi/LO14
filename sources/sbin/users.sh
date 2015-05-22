function userConfig {

    
    if [ ! -d /home/rvsh/user/$1 ]
    then
        echo "The user doesn't exist"
    else    
        userCmd=""
        while [ ! \( "$userCmd" = "exit" -o "$userCmd" = "e" \) ]
	    do
	        echo -e -n "${Red}rvsh config-$1 > $White"
		    read  userCmd 
		    echo -e -n "$NC"
	    done        
    fi
}


function userList {
    echo -e -n "$White"
    echo -e -n $(ls /home/rvsh/user)
    echo -e "$NC"
}

function addUser {

    if [ ! -d /home/rvsh/user/$1 ]
    then 
        mkdir /home/rvsh/user/$1
        echo -e "${White}The user $1 has been added.$NC"
    else
        echo -e "${White}The user $1 already exist.$NC"
    fi
}

function delUser {

    
    if [ -d /home/rvsh/user/$1 ]
    then 
        rmdir /home/rvsh/user/$1
        echo -e "${White}The user $1 has been removed.$NC"
    else
        echo -e "${White}The user $1 doesn't exist.$NC"
    fi

}

function user {

    if [ ! -d /home/rvsh/user ]
    then 
        mkdir /home/rvsh/user
    fi
    
    local OPTIND
    
    getopts "a:r:c:lh" OPTION
    
    case "$OPTION" in
        "a" ) addUser $OPTARG;;
        "r" ) delUser $OPTARG;;
        "c" ) userConfig $OPTARG;;
        "l" ) userList;;
        "h" ) echo "aide";;
    esac
}
