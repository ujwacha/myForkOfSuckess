#!/bin/bash


cat $HOME/.cache/german-vocab | sed "s/\t/    /g" | dmenu -l 20
