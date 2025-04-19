#!/usr/bin/env zsh

######################################################################
# flvconverter                                                       #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2020-07-31 Fri>                                        #
# PURP: Convert video file to flv.                                   #
#                                                                    #
# Converts a video file of some format using mencoder to flv format. #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: "
    echo "how: "
    exit
fi



#############
# Variables #
#############
if [ -z $1 ]; then
    echo "Enter File!"
    exit
fi

ifile=$1
ofile=${1%.*}.flv



########
# Main #
########

# a complicated mencoder command
mencoder $ifile -ofps 25 -o $ofile -of lavf -oac mp3lame -lameopts abr:br=64 -srate 22050 -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -ovc lavc -lavcopts vcodec=flv:keyint=50:vbitrate=300 -vf scale=320:213

# a manipulation tool for flv https://github.com/unnu/flvtool2
flvtool2 -UP $ofile

echo "All done!"


exit



#########
# Notes #
#########


