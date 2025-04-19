#!/usr/bin/env zsh

###################################################################
# Backups                                                         #
#                                                                 #
# AUTH: pradesigner                                               #
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
    echo "how: bkps.sh <pradmin|av|1|12|sd>"
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
    pradmin)
        # /home/pradmin to /zata/pradmin
        echo 'rsyncing to /zata/pradmin'
        rsync -aW --inplace --exclude={'.cache/','.git/'} --delete /home/pradmin /zata/
        ;;
    av)
        # av items to /zata
        rsync -rW --inplace --delete /home/xxx/zzhold /zata/xxx/
        rsync -rW --inplace --delete /home/vids /zata/
        ;;
    1)
        # backup pradmin, xxx to bkp1 (4T)
        #user=`id -u -n`
        #host=`hostname`
        echo 'backing up to 4T'
        sudo mount /dev/disk/by-uuid/334ec2f2-56f3-411d-ab04-429b5dc00ad2 /home/mnts/bkp1
        rsync -av --exclude={'.cache/','.git/'} --delete /home/pradmin /home/mnts/bkp1/
        rsync -av --delete /home/xxx /home/mnts/bkp1/av/
        sudo umount /home/mnts/bkp1
        ;;
    12)
        # backup bkp1 to bkp2 (both 4T)
        echo "backing up 4T bkp1 to 4T bkp2"
        sudo mount /dev/disk/by-uuid/334ec2f2-56f3-411d-ab04-429b5dc00ad2 /home/mnts/bkp1
        sudo mount /dev/disk/by-uuid/ba2b8254-12e0-4765-97c4-c95f81ad340a /home/mnts/bkp2
        rsync -av --delete /home/mnts/bkp1/av /home/mnts/bkp2/
        rsync -av --delete /home/mnts/bkp1/bkps /home/mnts/bkp2/
        rsync -av --delete /home/mnts/bkp1/pradmin /home/mnts/bkp2/
        sudo umount /home/mnts/bkp1
        sudo umount /home/mnts/bkp2
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
        echo 'stop messing it up!'
        echo 'usage: bkps.sh <pradmin|av|1|12|sd>'
        ;;

esac

echo "all done!"



exit



#########
# Notes #
#########

    # xxx)
    #     # xxx directory to usb stick NOLONGER USED
    #     sudo mount /dev/disk/by-uuid/6A5D-C350 /home/mnts
    #     sudo rsync -vrl --delete --exclude='zzhold' /home/xxx /home/mnts/
    #     sudo umount /home/mnts
    #     ;;



