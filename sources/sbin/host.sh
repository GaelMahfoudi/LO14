function host-list {
    
    echo -e -n "$White"
    echo -e -n $(ls /home/rvsh/host)
    echo -e "$NC"

}

function add-host {
    if [ ! -d /home/rvsh/host/$1 ]
    then 
        mkdir /home/rvsh/host/$1
        echo -e "${White}The host $1 has been added.$NC"
    else
        echo -e "${White}The host $1 already exist.$NC"
    fi
}

function del-host {
    if [ -d /home/rvsh/host/$1 ]
    then 
        rmdir /home/rvsh/host/$1
        echo -e "${White}The host $1 has been removed.$NC"
    else
        echo -e "${White}The host $1 doesn't exist.$NC"
    fi
}

function host {
    if [ ! -d /home/rvsh/host ]
    then 
        mkdir /home/rvsh/host
    fi
    
    local OPTIND
    getopts "a:r:lh" OPTION
    
    case "$OPTION" in
        "a" ) add-host $OPTARG;;
        "r" ) del-host $OPTARG;;
        "l" ) host-list;;
        "h" ) echo "aide";;
    esac
}
   
