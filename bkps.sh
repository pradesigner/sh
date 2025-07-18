#!/usr/bin/env zsh

###################################################################
# Backups                                                         #
#                                                                 #
# AUTH: pradesigner                                               #
# VDAT: v2 - <2025-05-11 Sun> (tumbleweed setup)                  #
# VDAT: v1 - <2023-07-31 Mon> (started before 2018)               #
# PURP: does various backups                                      #
#                                                                 #
# bkps.sh makes backups to /zata 4T as well as 4T -> 4T given the #
# appropriate argument. It also takes care of all mount/umount    #
# automatically, making use of /home/mnts directory.              #
###################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: makes backups given an argument"
    echo "how: bkps.sh [<4T|4T4T|sd>] || pradmin"
    exit
fi



#############
# Variables #
#############
arg=$1                          # parameter indicating which backup to do


########
# Main #
########
case $arg in
    4T)
        # backup pradmin, xxx to bkp1 (4T)
        #user=`id -u -n`
        #host=`hostname`
        echo 'backing up to 4T'
        sudo mkdir /mnt/4T
        sudo mount /dev/disk/by-uuid/334ec2f2-56f3-411d-ab04-429b5dc00ad2 /mnt/4T
        rsync -a --exclude={'.cache/','.git/'} --delete /home/pradmin /mnt/4T/
        rsync -a --delete /zata/srv/xxx /mnt/4T/av/
        sudo umount /mnt/4T
        sudo rmdir /mnt/4T
        ;;
    4T4T)
        # backup bkp1 to bkp2 (both 4T)
        echo "backing up 4T bkp1 to 4T bkp2"
        sudo mkdir /mnt/4T{1,2}
        sudo mount /dev/disk/by-uuid/334ec2f2-56f3-411d-ab04-429b5dc00ad2 /mnt/4T1
        sudo mount /dev/disk/by-uuid/ba2b8254-12e0-4765-97c4-c95f81ad340a /mnt/4T2
        rsync -a --delete /mnt/4T1/av /mnt/4T2/
        rsync -av --delete /mnt/4T1/bkps /mnt/4T2/
        rsync -av --delete /mnt/4T1/pradmin /mnt/4T2/
        sudo umount /mnt/4T1
        sudo umount /mnt/4T2
        sudo rmdir /mnt/4T?
        ;;
    sd)
        # backup ~/ocs to sdcard mounted with adapter (don't have 4T on)
        # on /run/media/pradmin/disk 
        # usage: jri (no need to open filemanager to mount in gnome)
        # as is, the rsync is very slow to usb - easier to just cp files over usually
        lsblk
        vared -p "Input the device (sdXN): " -c dev
        echo 'backing up ocs to sdcard on $dev'
        sudo mount "/dev/$dev" /home/mnts/sd
        sudo rsync -vrl --delete --exclude={'esign','ing'} ~/ocs /home/mnts/sd/ #fuse doesn't like -a
        sudo umount /home/mnts/sd
        ;;
    *)
        # /home/pradmin to /zata/pradmin
        echo 'rsyncing to /zata/pradmin'
        rsync -a --exclude={'.cache/','.git/'} --delete /home/pradmin /zata/
        ;;

esac

echo "all done!"



exit



#########
# Notes #
#########

modify 4T to follow jellyfin pattern of movies, shows, music etc.
this will require some thought.



