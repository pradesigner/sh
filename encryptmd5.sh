#!/usr/bin/env zsh

#####################################################################
# Encrypt md5                                                       #
#                                                                   #
# AUTH: pradesigner                                                 #
# VDAT: v1 - <2023-07-31 Mon> (used for a few years)                #
# PURP: Hashes a string to md5.                                     #
#                                                                   #
# Makes an md5 hash out of a given string by piping through md5sum. #
#####################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: generates md5 hash from given string"
    echo "how: md5hash.sh <string>"
    exit
fi



#############
# Variables #
#############
str=$1



########
# Main #
########
echo "encryptmd5 \"$1\""
echo -n $1 | md5sum


exit



#########
# Notes #
#########

