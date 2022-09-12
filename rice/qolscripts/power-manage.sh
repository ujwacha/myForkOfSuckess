#!/bin/bash

powerprofilesctl set  $(printf "power-saver\nbalanced\nperformance" | dmenu );

pkill -RTMIN+9 dwmblocks ;
