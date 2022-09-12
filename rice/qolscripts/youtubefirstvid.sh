#!/bin/bash

search=$(echo | dmenu -p "Search youtube video :" | tr ' ' '-')

link=$(curl -s https://vid.puffyan.us/search?q=$search | grep -Eo 'watch\?v=.{11}' | head -n 1)

video="https://www.youtube.com/$link"
notification "playing the youtube video" 5
mpv $video
