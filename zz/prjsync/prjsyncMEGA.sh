#!/usr/bin/env zsh

######################################################################
# praject rsync                                                      #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-07-01 Sat>                                        #
# PURP: rsyncs prajects to lentil                                    #
#                                                                    #
# prjsync.sh rsyncs entire prajects to lentil dirs. The script works #
# well, and is preferable to git for the purposes of making backups. #
# Log is always kept in the zzotes.org file at the top usually.      #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: uses rsync to backup specific prajects to lentil"
    echo "use: present prajects are"
    echo
    rclone ls mega:prajects
    echo
    echo "how: prjsync.sh u praductions|aa|sh|... || d praductions [aa sh ...]"
    echo "how: note that u only one, but d several"
    exit
fi



#############
# Variables #
#############
size=$#@
if [[ $size<2 ]]; then
    echo "usage: prjsync.sh u <prajectname> | d <prajectname[s]>"
    exit
fi

UD=$@[1]                         # u|d



#############
# Functions #
#############




########
# Main #
########
cd /home/pradmin                # do everything from ~/

case $UD in                     # set the processes for u|d where prajects always linked from ~/
    u)
        PD=$@[2]
        echo "uploading $PD"
        emacsclient -nw ~/$PD/zzlog.org # make entries in log
        rclone sync $2 -L mega:prajects/$2
        ;;
    d)
        for i in {2..$size}; do # cycle through all prajects to be downloaded
            PD=$@[$i]

            if [[ -d ~/$PD ]];  # check that there is a praject directory for the praject name
            then
                echo "downloading $PD"
                rclone sync mega:prajects/$PD -L $PD
            else
                echo "praject directory $PD does not exist!"
            fi

        done
        ;;
    *)
        echo "usage: prjsync.sh u|d <praject[s]"
        exit
        
esac


echo "all done"


exit



#########
# Notes #
#########


# altered so upload 1 praject, but download several <2023-09-23>
# script may be of use for several situations and should probably be improved !!!
