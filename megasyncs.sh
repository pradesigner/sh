#!/usr/bin/env zsh

########################################################################
# megasyncs script                                                     #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2025-05-02 Fri>                                          #
# PURP: sync various dirs to mega                                      #
#                                                                      #
# megasyncs.sh uses rclone to sync local -> mega dirs since the actual #
# megasync systems regularly fail.                                     #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: syncs dirs to mega"
    echo "how: jri"
    exit
fi



#############
# Variables #
#############
DIRS=("aa" ".emacs.d" ".zsh.d")



########
# Main #
########
for d in $DIRS; do
    echo "syncing $d to mega"
    rclone sync "/home/pradmin/$d" "mega:$d" --exclude-from ~/.rclone-exclude
done



exit



#########
# Notes #
#########
