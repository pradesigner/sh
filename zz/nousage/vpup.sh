#!/bin/bash
#   mogrifies, lowercases and uploads veganpoet pics

cd ~/Downloads/vp/

for f in *.[Jj][Pp][Gg]; do
    flc=$(echo $f | tr '[A-Z]' '[a-z]')
    mv $f $flc
    done

mogrify -scale 130 *.jpg

lftp -f vpvv

rm *.jpg

echo "All done"
