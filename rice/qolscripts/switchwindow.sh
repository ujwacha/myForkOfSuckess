 wmctrl -a $(wmctrl -l | awk '{$3=""; $2=""; $1=""; print $0}' | dmenu -i -l 8 -fn "-xos4-terminus-medium-r-*-*-20-*")

