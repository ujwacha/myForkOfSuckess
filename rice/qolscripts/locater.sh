#!/bin/bash

# : '
# this script searches for a file within the home directory using locate . the search is case insensetive 
# this script was written by Ujwol Acharya
# '

sfile=$(echo | dmenu -p find:)
## this just asks for an input from the user and stores the input in a variable

bash $HOME/.search-setter.sh

sfile=$(cat $HOME/.cache/search-data | grep -i $sfile | dmenu -l 35 -p open:)

###$(locate -i $sfile | grep "$HOME" | dmenu -l 35 -p open:) 
### this first does a systemwide case insensative search 
### then ,the stdout is sent to grep , where only those things within the home directory are putputed in stdout
### and like a unix chad , we pipe in the grep stdout to dmenu , and store the selection in a variable

###launcher=$(echo -n "st -e nvim"| dmenu -p "launch $file with:") 
##launcher=$( echo "xdg-open" | cat - $HOME/.cache/dmenu_run | dmenu -l 2 -p "launch $sfile with:")



launcher=$(cat $HOME/.cache/dmenu_run | dmenu -l 2 -p "launch $sfile with:")
### here , we just select the program to open up the file , nvim is the default one here

if [ $launcher == "[" ]
then
	launcher="emacsclient -c"
fi


$launcher "$sfile"
### here we just launch the file with the program selected


