#!/bin/bash

battery=$(cat /sys/class/power_supply/BAT0/capacity);
if (( $battery >= 80 ))
then
	echo -n " "
elif (( $battery >= 50 ))
then    
    	echo -n " "
elif (( $battery >= 10 ))
then
	echo -n " "
elif [ "$battery" == "" ]
then
	echo -n ""
else
	echo -n " %"
fi

echo $battery
