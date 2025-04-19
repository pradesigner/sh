#!/usr/bin/env zsh

########################################################################
# ts to video                                                          #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2023-08-01 Tue>                                          #
# PURP: Make mp4 from ts segments                                      #
#                                                                      #
# ts2mp4.sh joins ts segments to create an mp4 video given the beg and #
# end numbers.                                                         #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: creates video from ts segments"
    echo "how: ts2mp4.sh movie-title beg end url"
    exit
fi



#############
# Variables #
#############
tle=$1                          # title of movie
beg=$2                          # beg of ts usually 0001
end=$3                          # end of ts (look it up on movie end)
url=$4                          # url replace ts numbers with NNNN



########
# Main #
########
# create working directory
mkdir ~/Videos/$tle
cd ~/Videos/$tle

# create ts file with urls to download
for n in {$beg..$end}; do
    echo ${url:s/NNNN/$n/}
done > ts

# download the ts files as mp4
youtube-dl -a ts -o "%(autonumber)s-$tle.mp4"

# put the mp4 files together
ls -1 *.mp4 > list
sed -i 's/^/file /' list

# create the single mp4
ffmpeg -f concat -i list -c copy $tle.mp4

# clean up
mv $tle.mp4 ../
cd ../
rm -r $tle


exit



#########
# Notes #
#########




