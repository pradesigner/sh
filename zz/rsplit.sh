#!/usr/bin/env bash
#TODO
if [[ $1 == '-h' ]]; then
    echo "use: rsplit uses csplit but does so from the end"
    echo "how: rsplit filename pattern"
    exit
fi


tac "$1" > tmp
csplit tmp "$2"
tac xx00 > thefile
rm xx*
rm tmp

exit
