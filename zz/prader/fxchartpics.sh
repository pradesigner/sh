#!/usr/bin/env bash

# converts chart png to jpg and moves to ~/fxcm/imgs
# usage: jri

cd ~/VirtuShare

for e in *.png; do
    convert $e ${e%.*}.jpg
    mv ${e%.*}.jpg ~/fxcm/imgs
    rm $e
done

echo "all done"
