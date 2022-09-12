#!/bin/bash

sleep 40m
mpv ~/Music/NeverGonnaGiveYouUp.mp3 &
echo "it's time for an anime ep" | dmenu >> /dev/null 
killall mpv 
