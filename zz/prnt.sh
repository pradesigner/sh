#!/usr/bin/env bash

# print document from console TODO
# usage: prnt FILE PRINTER SIDES

F=$1 #filepath
P=$2 #printer
S=$3 #sides

if [[ $P = '' ]]; then
    P='horizon'
fi

if [[ $S = '' ]]; then
    S='one-sided'
else
    S='two-sided-long-edge'
fi

lp -d $P -o sides=$S $F

