#!/bin/bash

MountPoint=$HOME/cell

MountDevice=$(simple-mtpfs -l | dmenu -p "Mount Device :"| awk '{printf $1}' | tr ':' '\0')

simple-mtpfs --device $MountDevice $MountPoint

echo $MountPoint > $HOME/.cache/mountpoint
