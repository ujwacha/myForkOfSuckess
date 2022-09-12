#!/bin/bash

#### get the bssid and password
## " sed -n '1!p' " removes the first line

line=$(nmcli device wifi list | sed -n '1!p' | dmenu -p "Wifi :" -l 30)
bssid=$(echo $line | awk '{print $1}')
ssid=$(echo $line | awk '{print $2}')

if [ "$bssid" == "" ]
then
	notification "EXITED WIFI.SH | " 5
	exit
fi

pass=$(echo | dmenu -p "password")


##### use nmcli to connect to wifi

nmcli device wifi connect $bssid password $pass && notification "conecting to $ssid" 5
