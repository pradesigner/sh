#!/usr/bin/env zsh

##########################################################################
# video join complex                                                     #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Joins video with suitable complexity                             #
#                                                                        #
# vidjoinc.sh joins name{1..x}.mp4 into name.mp4 going through           #
# mts. Though it works reasonably well, we likely will not use it        #
# without serious examination because it does not always seem to         #
# work. Video joining tools such as shotcut do the job with greater      #
# ease. Also see vidjoins.sh which is the simple join program that works #
# well on certain files.                                                 #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: joins videos reasonably well"
    echo "how: join-mp4.sh <basename>"
    exit
fi



#############
# Variables #
#############
BN=$1



########
# Main #
########
# converts to mts then back to mp4
# uses oneliner instead of temporary list.txt file

# create and join mts files
for f in $BN*.mp4; do
    ffmpeg -i ${f} -q 0 "${f%.*}.mts"
done

ffmpeg -f concat -safe 0 -i <(for f in *.mts; do echo "file '$PWD/${f}'"; done) -c copy $BN.mts

# convert to mp4
ffmpeg -i $BN.mts $BN.mp4

rm *.mts



exit



#########
# Notes #
#########



###### expts ######
# this is same as the vidjoinS.sh and produces the incorrect timeline error
ffmpeg -f concat -safe 0 -i <(find . -name '*.mts' -printf "file '$PWD/%p'\n" | sort) -c copy all.mp4

# this also produces timeline error
ffmpeg -safe 0 -f concat -i <(find . -type f -name '*.mp4' -printf "file '$PWD/%p'\n" | sort) -c copy output.mkv
