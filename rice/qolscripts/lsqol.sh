#!/bin/bash

bash $HOME/.qolscripts/$(ls $HOME/.qolscripts | sed 's/.sh//g' | dmenu -i -p run:).sh 2>/dev/null ;
