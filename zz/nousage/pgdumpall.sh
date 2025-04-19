#!/bin/bash
# dumpall postgresql content to pgdumps by date
# usage: pgdumpall computer

computer=$1

cd /home/pradmin/dmps

if [[ $computer == gom ]]; then
    pg_dumpall > $computer`date "+%Y%m%d"`.dmp
else
    ssh -p 929 $computer pg_dumpall > $computer`date "+%Y%m%d"`.dmp
fi
