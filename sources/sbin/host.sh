# chemin d'accès à la racine de rvsh
ROOT="$HOME/rvsh"

host_list() {
    
    list=$(ls -Al $ROOT/host/ | awk 'NR > 1 {print $NF}')
    if [ -z "$list" ]; then
        echo "No VMs created"
    else
        echo "$list"
    fi
}

add_host() {

    if [ ! -d $ROOT/host/$1 ]; then 
        mkdir $ROOT/host/$1
        echo -e "The host $1 has been added."
    else
        echo -e "The host $1 already exist."
    fi

}

del_host() {
    if [ -d $ROOT/host/$1 ]; then 
        rmdir $ROOT/host/$1
        echo -e "The host $1 has been removed."
    else
        echo -e "The host $1 doesn't exist."
    fi
}

help_host() {

    echo "usage: host [-arlh]"
    echo ""
    echo "  -h    show this help and quit"
    echo "  -a    add a VM"
    echo "  -r    remove a VM"
    echo "  -l    list all VM"
    echo ""
}

host() {
    
    if [ ! -d $ROOT/host ]; then 
        mkdir $ROOT/host
    fi
    
    local OPTIND
    
    while getopts "a:r:lh" opt; do
    
        case "$opt" in
            "a" ) add_host $OPTARG;;
            "r" ) del_host $OPTARG;;
            "l" ) host_list;;
            "h" ) help_host;;
             *) help_host;;
        esac

    done
}