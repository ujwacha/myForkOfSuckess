#!/bin/bash
xbacklight -set $(printf "0.1\n0.3\n0.5\n1\n10\n20\n30\n40\n50\n60\n70\n80\n90\n100" | dmenu -p "Brightness Level :"i)

notification "brightness: $(xbacklight)" 2
