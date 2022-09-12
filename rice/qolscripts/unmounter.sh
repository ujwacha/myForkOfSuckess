#!/bin/bash

MountPoint=$(cat $HOME/.cache/mountpoint)

fusermount -u $MountPoint
rm $HOME/.cache/mountpoint
