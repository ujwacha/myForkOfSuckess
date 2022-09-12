#!/bin/bash


wal --backend $(printf "schemer\ncolorthief\nwal\ncolorz\nhaishoku" | dmenu -p backend:) -i $1 && st -e sudo sh $HOME/.scripts/rebuild.sh && killall dwm ;
