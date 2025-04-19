#!/usr/bin/env zsh

######################################################################
# ts download                                                        #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-08-01 Tue>                                        #
# PURP: Download ts files listed in m3u8 file                        #
#                                                                    #
# tsdl.sh downloads from movie sites that stream .ts listed in .m3u8 #
# file at least some of them popcornflix is not one of those.        #
######################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: download the ts files listed in m3u8"
    echo "how: tsdl.sh <moviename> <url.m3u8>"
    exit
fi



#############
# Variables #
#############
moviename=$1
url=$2



########
# Main #
########
# cd ~/Videos
# mkdir $moviename
# cd $moviename

# # get the m3u8 file
# curl -o $moviename.m3u8 $url

# get the .mp4 files listed in the  m3u8
youtube-dl -a $moviename.m3u8 -o "%(autonumber)s-$moviename.mp4"

# create listing of the .mp4 files suitable for ffmpeg
ls -1 *.mp4 | sed 's/^/file /' > filelist

# join individual .mp4 partial files together
ffmpeg -f concat -i filelist -c copy $moviename.mp4

mv $moviename.mp4 ../
cd ..
rm -r $moviename


exit



#########
# Notes #
#########


# need to examine this program because it may not work !!!
