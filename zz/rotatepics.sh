#!/usr/bin/env bash

# rotates pic given odd or even
# usage: rotatepics.sh 0 (even) | 1 (odd)

# if the last digit % 2 gives 0 then rotate even pages
# if the last digit % 2 gives 1 then rotate odd  pages
# so $RM sets odd or even pages to rotate

RM=$1

for e in *.jpg; do
    N=${e:8:1}
    REM=$(( $N % 2 ))
    if [ $REM -eq $RM ]
    then
        mogrify -rotate 180  $e
    fi
    convert $e $e.pdf
done    
    

