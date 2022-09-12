#!/bin/bash

surf https://duckduckgo.com/\?q=$(echo | dmenu -p "duckduckgo search :" | tr ' ' '+' | tr '\n' '+')

