#! /bin/bash

pamixer -$1 5 ;
pamixer --get-volume > /home/light/.scripts/data/vol

