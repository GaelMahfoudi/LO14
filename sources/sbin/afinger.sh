function name {

    
}

function add-host {
    
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
