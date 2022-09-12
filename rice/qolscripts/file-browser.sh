#!/bin/bash

file=$(bash $HOME/.scripts/file-browser.sh)

launcher=$( echo "xdg-open" | cat - $HOME/.cache/dmenu_run | dmenu -l 2 -p "launch $sfile with:")

if [ $launcher == "[" ]
then
	launcher="st -e nvim"
fi

$launcher $file
