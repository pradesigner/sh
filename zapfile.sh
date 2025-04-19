#!/usr/bin/env zsh

#######################################################
# zap a file                                          #
#                                                     #
# AUTH: pradesigner                                   #
# VDAT: v1 - <2021-08-01 Sun>                         #
# PURP: Null file                                     #
#                                                     #
# zapfile.sh nulls a file by wiping out its contents. #
#######################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: zaps file content to empty"
    echo "how: zapfile.sh <file>"
    exit
fi



#############
# Variables #
#############
filename=$1



########
# Main #
########
ls -l $filename
cat /dev/null > $filename
ls -l $filename


exit



#########
# Notes #
#########




