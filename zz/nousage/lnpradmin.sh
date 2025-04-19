#!/bin/sh
# links directories from /data/pradmin to /home/pradmin

DP=/data/pradmin
HP=/home/pradmin

for f in $(ls $DP)
do
    DPdir=$DP/$f
    if [ -d $DPdir ]; then
	ln -sf $DPdir $HP/$f
    fi
done