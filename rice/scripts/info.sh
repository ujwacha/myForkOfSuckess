#! /bin/bash

usedMem=$(( $(free -m | awk '/Mem/ {print $3}') + $(free -m | awk '/Mem/ {print $5}') )) ;
Mem=$(free -m | awk '/Mem/ {print $2}') ;
date=$(date | awk '{print $2,$3}') ;
time=$(date | awk '{print $4}' | awk '{print substr ($0 , 0 ,5)}') ;
heat=$(sensors | awk '/CPU/ {print $2}' | sed 's/+//') ;
net=$(nmcli -t -f NAME connection show --active) ;
vol=$(pamixer --get-volume);
######cpu=$() ;

count=1 ;

function update() {

	xsetroot -name "  $net |  $usedMem/$Mem |  $heat |  $vol |  $date |  $time " ;


}




while true 
do	
	
	#### Update every second ###

	vol=$(pamixer --get-volume);
	heat=$(sensors | awk '/CPU/ {print $2}' | sed 's/+//') ;
	
	if (( $count % 15 == 0 ))
	then
		usedMem=$(( $(free -m | awk '/Mem/ {print $3}') + $(free -m | awk '/Mem/ {print $5}') )) ;
		Mem=$(free -m | awk '/Mem/ {print $2}') ;
			
	fi

	if (( $count % 30 ==  0 ))
	then
		
		time=$(date | awk '{print $4}' | awk '{print substr ($0 , 0 ,5)}') ;
		
	
	fi

	if (( $count % 120 == 0 ))
	then
		
		net=$(nmcli -t -f NAME connection show --active) ;
		
	fi

	if (( $count % 900 == 0 ))
	then
		
		date=$(date | awk '{print $2,$3}') ;
		

	fi


	
	update ;

	sleep 1 ;
	count=$(( $count + 1 ))
done
