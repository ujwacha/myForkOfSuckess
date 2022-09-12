#!/bin/bash

mpv $HOME/Music/$( ls $HOME/Music | dmenu -l 25) ;
