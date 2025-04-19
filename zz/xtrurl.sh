#!/usr/bin/env bash
#TODO
# extract urls from a existent file in dir or from a webpage
# usage: urlxtract.sh FILE

if [ -e $1 ]; then
    cat "$1" | grep -i "http:" | sed "s/^.*http/http/" | cut -f1 -d '"' | sort -u
else
    wget -O - "$1" | grep -i "http:" | sed "s/^.*http/http/" | cut -f1 -d '"' | sort -u
fi

### redo this !!! ###
