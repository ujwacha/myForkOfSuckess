#!/bin/bash

INITIAL=".initial-for-renaming.temp.ren"
FINAL=".final-for-rename.temp.ren"

ls > $INITIAL

cp $INITIAL $FINAL

vim $FINAL

FINALNUMBER=$(cat $FINAL | wc -l)
INITIALNUMBER=$(cat $INITIAL | wc -l)

if (( $FINALNUMBER != INITIALNUMBER ))
then
    echo "This script does not allow you to delete stuff, the total number initial files and final files does not match"
    exit
fi

for (( i=1 ; i <= $FINALNUMBER ; i++ ))
do
    mv  "$(cat $INITIAL | head -$i | tail -1)" "$(cat $FINAL | head -$i | tail -1)" >> /dev/null
done

rm $INITIAL $FINAL 
echo "FILES RENAMED"
