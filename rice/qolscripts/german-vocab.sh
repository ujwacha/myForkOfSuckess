#!/bin/bash

deutch=$( echo | dmenu -p "ein neu deutche wort " ) 
english=$( echo | dmenu -p "was bedeutet das auf english " )

printf "%s\t%s\n" $deutch $english >> $HOME/.cache/german-vocab

lines=$(wc -l $HOME/.cache/german-vocab | awk '{print $1}')

notification "$lines Wörter im database" 3
