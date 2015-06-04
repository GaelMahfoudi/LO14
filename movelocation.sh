#!/bin/bash

move_location(){

	local old_location=$1
	local direction=$2
	new_location=$old_location

	if [ "$direction" = ".." ]
	then
		new_location=$(echo $old_location | sed 's/\/.*$//g')
	else
		new_location=$old_location"/$direction"
		echo $new_location
	fi
} 