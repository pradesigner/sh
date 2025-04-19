#!/usr/bin/env zsh

if [[ $1 == '-h' ]]; then
    echo "use: rm,mv,cp mirrored on another device"
    echo "how: xxxmod.sh <rm|mv> <initial pattern> [<initial destination pattern>] from /home/xxx"
    exit
fi



# TODO

HOMDIR=/home/xxx
MNTDIR=/mnt/xxx
PAT=$2
DES=$3
UMNT=no

sudo mount /dev/disk/by-uuid/6A5D-C350 /mnt

case $1 in
    rm)
        # remove a file
        CMD=rm
        echo $CMD $HOMDIR/$PAT
        $CMD $HOMDIR/$PAT
        echo sudo $CMD $MNTDIR/$PAT
        sudo $CMD $MNTDIR/$PAT
        #sudo $CMD ${PAT:s/home/mnt/}
        ;;
    rl)
        # relocate a file to another directory
        CMD=mv
        FIL=${2##*/}
        echo $CMD $HOMDIR/$PAT $HOMDIR/$DES/$FIL
        $CMD $HOMDIR/$PAT $HOMDIR/$DES/$FIL
        echo sudo $CMD $MNTDIR/$PAT $MNTDIR/$DES/$FIL
        sudo $CMD $MNTDIR/$PAT $MNTDIR/$DES/$FIL
        #sudo $CMD ${PAT:s/home/mnt/} ${DES:s/home/mnt/}$FIL
        ;;
    rn)
        # rename file (no slashes)
        CMD=mv
        echo $CMD $HOMDIR/$PAT $HOMDIR/${PAT%/*}/$DES
        $CMD $HOMDIR/$PAT $HOMDIR/${PAT%/*}/$DES
        echo sudo $CMD $MNTDIR/$PAT $MNTDIR/${PAT%/*}/$DES
        sudo $CMD $MNTDIR/$PAT $MNTDIR/${PAT%/*}/$DES
        ;;
    *)
        # usage guide
        echo "rm - remove; rl - relocate; rn - rename"
esac

sudo umount /mnt


exit
