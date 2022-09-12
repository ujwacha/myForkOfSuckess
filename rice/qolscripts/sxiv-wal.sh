#!/bin/bash

wal --backend $(printf "schemer\ncolorthief\nwal\ncolorz\nhaishoku" | dmenu -p backend:) -i $1 && sudo sh ~/.scripts/rebuild.sh && killall dwm ;
