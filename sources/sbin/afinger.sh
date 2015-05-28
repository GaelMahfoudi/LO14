function name {

    local userpath="home/rvsh/user/"
    local tmp=($1)
    local old=${tmp[0]}
    local new=${tmp[1]}
    
    mkdir $userpath$new
    cp -r $userpath$old/* $userpath$new
    rm -r $userpath$old
}

function add-host {
    local userpath="home/rvsh/user/"
    local newhost=$1
    echo -e "$1\n" >> $userpath/hostlist
}

function afinger  {
    
    local OPTIND
    getopts "n:a:h" OPTION
    
    case $OPTION in
        "n" ) name "$OPTARG";;
        "a" ) add-host "$OPTARG";;
        "h" ) echo "aide";;
    esac
}
