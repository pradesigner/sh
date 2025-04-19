#!/usr/bin/env zsh

######################################################################
# Video from m3u8                                                    #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-08-01 Tue>                                        #
# PURP: Use m3u8 file to produce video                               #
#                                                                    #
# m3u8-dl.sh uses ffmpeg on the series of items in an m3u8 file to   #
# produce an mp4 video. The m3u8 url should be in quotation marks to #
# maintain integrity.                                                #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: downloads from m3u8 file"
    echo "how: m3u8-dl.sh "<url>" <outfile>"
    exit
fi



########
# Main #
########
ffmpeg -i "$1" -c copy -bsf:a aac_adtstoasc "$2.mp4"


exit



#########
# Notes #
#########


