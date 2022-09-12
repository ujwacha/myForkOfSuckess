#!/bin/bash

mode=$(powerprofilesctl list | awk '/*/ {print $2}' |sed 's/://') 

if [ "$mode" = "power-saver" ]
then
	echo ""
elif [ "$mode" = "balanced" ]
then
	echo ""
elif [ "$mode" = "performance" ]
then
	echo ""
else
	echo "something wrong"
fi

