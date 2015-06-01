ROOT="/home/rvsh"


who_is_connected_on() {

	local hostname="$1"

	for conn in $(ls $ROOT/host/$hostname/*.tmp  2> /dev/null); do

		printf "$hostname:\n"
		printf "%-12s %-9s %-9s\n" "user" "hour" "date"
		echo   "------------ --------  --------"

		cat $conn | awk -F',' '{printf "%-12s %-9s %-9s\n", $1, $2, $3	}'
		printf "\n"
	done

}