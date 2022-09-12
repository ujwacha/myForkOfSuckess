#!/bin/bash
wal --backend $(printf "schemer\ncolorthief\nwal\ncolorz\nhaishoku" | dmenu -p backend:) -i ~/Pictures/$(ls ~/Pictures | dmenu -i) && sudo sh ~/.scripts/rebuild.sh && killall dwm ;
