#!/bin/bash
#
#
#



################## function ##################




##################  Script  ##################

cmd=""



#Paramètre rvsh
connectMode=$1
user=$2
machine=$3



if [ ! $connectMode!="-connect" -o $connectMode!="-admin" ]
then
		echo "Error"
fi

 

if [ "$connectMode"=="-connect" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "$user@$machine > " cmd
	done

fi


if [ "$connectMode"=="-admin" ]
then

	while [ ! "$cmd" = "exit" ]
	do
		read -p "$user@$machine \# " cmd
	done

fi






