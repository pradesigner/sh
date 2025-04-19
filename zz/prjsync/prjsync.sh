#!/usr/bin/env zsh

######################################################################
# praject rsync                                                      #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-07-01 Sat>                                        #
# PURP: rsyncs prajects to /zata/prajects                            #
#                                                                    #
# prjsync.sh rsyncs entire prajects to /zata dirs. The script works  #
# well, and is preferable to git for the purposes of making backups. #
# Log is always kept in the zzotes.org file at the top usually.      #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: uses rsync to backup specific prajects to /zata/prajects"
    echo "use: present prajects are"
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

# modify script for host
host=`hostnamectl hostname`
if [[ $host == "admins" ]]
then
    base="/zata"
else
    base="admins:/zata"
fi



#############
# Functions #
#############
syncit () {                     # $1 $FRD, $2 $TOD
    rsync -av --update --delete --exclude-from=$HOME/sh/prjxclude "$1/" "$2"
}



########
# Main #
########
cd /home/pradmin                # do everything from ~/

case $UD in                     # set the processes for u|d where prajects always linked from ~/
    u)
        FRD=$@[2]
        TOD="$base/prajects/$FRD"
        echo "uploading $FRD"
        emacsclient -nw ~/$FRD/zzlog.org # make entries in log
        syncit "$FRD" "$TOD"
        ;;
    d)
        for i in {2..$size}; do # cycle through all prajects to be downloaded
            TOD="$@[$i]"
            FRD="$base/prajects/$TOD"
            if [[ -d ~/$TOD ]];  # check that there is a praject directory for the praject name
            then
                echo "downloading $FRD"
                syncit "$FRD" "$TOD"
            else
                echo "praject directory $FRD does not exist!"
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
