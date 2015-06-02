#!/bin/bash

# =====================================================================
#
#			FILE : write.sh
#
#		   USAGE : write.sh [user@vm] [Message to send]
#
#	 DESCRIPTION : Send a message to the user specify who is connected
#				   on the specified virtual machine.
#
#
#		  OPTION : see write_usage function
#		  AUTHOR : Gaël Mahfoudi & Simon Juhel
# =====================================================================



ROOT="$HOME/rvsh"


# ====  WRITE  ========================================================
#
#		 NAME : write
# DESCRIPTION : Send a message to the user specify who is connected
#				on the specified virtual machine.
# PARAMETER $1: String where the first word is "user@vm" and the
#				rest is the message to send.
#			$2: Is the name of the sender.
# =====================================================================

write() {

	cible=($1)
	cible=${cible[0]}

	msg=${1:$((${#cible[0]}+1))}

	cible=$(echo $cible | awk -F "@" '{print $1}')
	

	if [ ! -d $ROOT/users/$cible/msg/ ]
	then
		mkdir $ROOT/users/$cible/msg/
	fi
	
	sender="$2.$(date +%H%M%N)"
	echo -e $msg > $ROOT/users/$cible/msg/$sender

}