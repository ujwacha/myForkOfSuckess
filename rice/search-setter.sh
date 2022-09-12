#!/bin/bash

##find .  -path ./.cache -prune -path ./.mozilla  -prune -path ./.emacs.d -prune -o  -print > $HOME/.cache/search-data

#find .  -path ./.cache -prune -path ./.mozilla  -prune -o  -print > $HOME/.cache/search-data

find . -type d \( -path ./.cache -o -path ./.mozilla -o -path ./.emacs.d -o -path ./.local -o -path ./.steam -o -path ./.zoom -o -path ./.var \) -prune -o  -print > $HOME/.cache/search-data
