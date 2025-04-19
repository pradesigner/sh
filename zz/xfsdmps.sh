#!/bin/bash
#does xfsdump to external hd for vz home data TODO
#usage: xfsdmps

FILESYSTEMS='/var/lib/vz /home /data'
LV=$(( $(date +%w) + 1))

sudo mount /dev/disk/by-uuid/29541ed6-f662-4e68-a1d1-86930f29b304 /media/extdr
MNT=/media/extdr

#MNT=/media/29541ed6-f662-4e68-a1d1-86930f29b304 (used with nautilus)

cd $MNT

for FS in $FILESYSTEMS; do
    FN="${FS##*/}$LV.xfs"
    echo
    echo "doing ... level$LV $FN $FS"
    echo
    if [ -f $FN ]
    then
        sudo rm $FN
    fi
    sudo xfsdump -l $LV -L level$LV -M extdr -f $FN $FS
    echo
    ls -lh /mnt
    echo
done

echo "unmounting ..."
cd /home/pradmin
sudo umount $MNT

echo "xfsdumps process completed!"


### redo this !!! ###

