#!/usr/bin/env bash

# sets up csv files in directories
# usage: 2_setdirs.sh <tickdata dir>

cd $1
getpairs=$(ls | cut -c 1-6 | uniq)

for f in $getpairs;do
    mkdir $f
    mv ${f}*.csv $f
done




