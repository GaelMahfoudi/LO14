ROOT="/home/rvsh"

source who.sh

rusers() {

	for host in $(ls $ROOT/host/); do

		who_is_connected_on $host

	done

}