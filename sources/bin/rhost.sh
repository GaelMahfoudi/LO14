# dossier racine de rvsh
ROOT="$HOME/rvsh"

rhost() {

	echo "[*] VMs available on the network"

	list=$(ls $ROOT/host/)
    if [ -z "$list" ]; then
        echo "No VMs created"
    else
        echo "$list"
    fi

}