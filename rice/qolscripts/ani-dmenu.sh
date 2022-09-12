#!/bin/bash

### dependencies : grep , sed , mpv , curl , dmenu , awk , tail
file=$HOME/.cache/ani-dmenu-hist
anime_id=$(cat $file | tail -n 1 | awk '{print $1}')
ep_no=$(cat $file | tail -n 1 |awk '{print $2}')

Temp=$HOME/.cache/ani-dmenu-temp

#this is the domain , if one day you find this script and if i have already stopped maintaining this and if gogoanime still exists , just change the Domain variable to the domain name of gogoanime . or you can just go to https://github.com/pystardust/ani-cli and copy the domain they have put ! thank you for using this crap script ......

### those guys at ani-cli are so cool , they figured out a way to scrape even the fucking domain . Wish i was as good as them
base_url=$(curl -s -L -o /dev/null -w "%{url_effective}\n" https://gogoanime.cm)

quality=best


##### this is a fork of ani-cli but for dmenu
##### credit to the developers of https://github.com/pystardust/ani-cli for all the functions used


###########base_url=$(curl -s -L -o /dev/null -w "%{url_effective}\n" https://gogoanime.cm)



search_anime () {
	# get anime name along with its id for search term
	search=$1
	curl -s "$base_url//search.html" -G -d "keyword=$search" |
		sed -n -E 's_^[[:space:]]*<a href="/category/([^"]*)" title="([^"]*)".*_\1_p'
}



search_eps () {
	# get available episodes for anime_id
	anime_id="$1"
	curl -s "$base_url/category/$anime_id" |
	sed -n -E '
		/^[[:space:]]*<a href="#" class="active" ep_start/{
		s/.* '\''([0-9]*)'\'' ep_end = '\''([0-9]*)'\''.*/\2/p
		q
		}
		'
}




decrypt_link() {
    secret_key='3633393736383832383733353539383139363339393838303830383230393037'
    iv='34373730343738393639343138323637'
    ajax_url="https://gogoplay4.com/encrypt-ajax.php"
    id=$(printf "%s" "$1" | sed -nE 's/.*id=(.*)&title.*/\1/p')

    ajax=$(echo $id|openssl enc -e -aes256 -K "$secret_key" -iv "$iv" | base64)

    data=$(curl -s -H "X-Requested-With:XMLHttpRequest" "$ajax_url" -d "id=$ajax" | sed -e 's/{"data":"//' -e 's/"}/\n/' -e 's/\\//g')
    
    printf '%s' "$data" | base64 -d | openssl enc -d -aes256 -K "$secret_key" -iv "$iv" | sed -e 's/\].*/\]/' -e 's/\\//g' |
        grep -Eo 'https:\/\/[-a-zA-Z0-9@:%._\+~#=][a-zA-Z0-9][-a-zA-Z0-9@:%_\+.~#?&\/\/=]*'
}


get_dpage_link() {
	# get the download page url
	anime_id="$1"
	ep_no="$2"
	# credits to fork: https://github.com/Dink4n/ani-cli for the fix 
	for params in "-episode-$ep_no" "-$ep_no" "-episode-$ep_no-1" "-camrip-episode-$ep_no"; do
		anime_page=$(curl -s "$base_url/$anime_id$params")
		printf '%s' "$anime_page" | grep -q '<h1 class="entry-title">404</h1>' || break
	done
	printf '%s' "$anime_page" |
		sed -n -E 's/.*class="active" rel="1" data-video="([^"]*)".*/\1/p' | sed 's/^/https:/g' 
}



get_video_quality() {
	# chooses the link for the set quality
	dpage_url="$1"
	video_links=$(decrypt_link "$dpage_url")
	case $quality in
		best)
			video_link=$(printf '%s' "$video_links" | head -n 4 | tail -n 1)
			;;
		worst)
			video_link=$(printf '%s' "$video_links" | head -n 1)
			;;
		*)
			video_link=$(printf '%s' "$video_links" | grep -i "${quality}p" | head -n 1)
			if [ -z "$video_link" ]; then
				err "Current video quality is not available (defaulting to best quality)"
				quality=best
				video_link=$(printf '%s' "$video_links" | head -n 4 | tail -n 1)
			fi
			;;
	esac
	printf '%s' "$video_link"
}



open_episode () {
	anime_id="$1"
	episode="$2"
	# decrypting url
	dpage_link=$(get_dpage_link "$anime_id" "$episode")

	dummy=$dpage_link

	if [ -z "$dpage_link" ];then 
	    echo "Episode doesn't exist!!" | dmenu ;
	else
	    video_url=$(get_video_quality "$dpage_link")
	fi

	
	trackma_title=$(printf '%s' "$anime_id" | tr '-' ' ' ) 

	##### play the video from mpv
	mpv --referrer="$dpage_link" $video_url --force-media-title="$trackma_title $episode" > /dev/null & 
	
}

final () {

	anime=$1
	ep=$2
        max=$(search_eps $anime_id)
	if [ $ep -lt 1 ] || [ $ep -gt $max ]
	then 
			echo "the ep is out of range" | dmenu >> /dev/null
			exit ;
	fi
	notification "playing the anime episode" 5 &
	open_episode $anime $ep


}

########
##main##
########

##### options ########
op1="next_ep"
op2="replay_ep"
op3="previous_ep"
op4="search_anime"
op5="history"

wat=$(printf "%s\n%s\n%s\n%s\n%s" $op1 $op2 $op3 $op4 $op5 | dmenu) ;



case $wat in
        $op1 )
                ep_no=$(( ep_no + 1 ))

		;;
        $op2 )

                ### continue ;
                ;;
        $op3 )

                ep_no=$(( ep_no -1 ))
                ;;
        $op4 )
                search_anime $(echo | dmenu -p "Search Anime :" | tr ' ' '-' ) > $Temp
                anime_id=$(cat $Temp | dmenu -l 20 -p "Select Anime :")
                max=$(search_eps $anime_id)

                ep_no=$(echo | dmenu -p "ep no[max:"$max"]")
		rm $Temp
                ;;
	$op5)
		sector=$(cat $file | dmenu -l 10 -p "History :") 
		ep_no=$(echo $sector | awk '{print $2}' )
		anime_id=$(echo $sector | awk '{print $1}' )
		;;
        * )

                echo " right option not selected " | dmenu >> /dev/null
                exit
                ;;

        esac

# use the final function to play the anime episoide

final $anime_id $ep_no

## here , we check if the anime_id is in the file. if it is there , that line has to be deleted

LineToDelete="$(grep " $anime_id " $file )" 

if [ "$LineToDelete" != "" ] 
then
	## redirecting it to a temporary file so that nothing gets fucked up
	sed -i  "s/$LineToDelete//" $file #### these parts are commented because they were a part of the script back then but are not right noe > "$file.temp"
	###  cat "$file.temp" > $file
	###  rm "$file.temp"
fi

### append the last anime and ep no in the history file
printf " %s %s\n" $anime_id $ep_no >> $file

### remove all empty lines from the history file to make the data clean

sed -i '/^$/d' $file
