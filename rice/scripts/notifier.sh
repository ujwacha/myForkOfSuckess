#!/bin/bash

## saving the given input in a variable and exporting it throught the system inb that login instance
var="$1";
echo $var > /home/light/.cache/notification ;
pkill -RTMIN+11 dwmblocks ;
