#!/usr/bin/env zsh

##########################################################################
# Download Program for videos                                            #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-01-01 Sun>                                            #
# PURP: Downloads videos                                                 #
#                                                                        #
# dlp.sh uses links to videos on youtube, tubi and various other sites   #
# to do downloads using yt-dlp an improved version of youtube-dl. The    #
# program grabs the best or 720 res format. The links are listed in      #
# ~/Videos/zvids, but the actual files will be downloaded into the       #
# directory that dlp.sh is run from and on completion, the zvids file is #
# zapped.                                                                #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: download video given url"
    echo "how: jri  after entering urls in ~/Videos/zvids"
    exit
fi



#############
# Variables #
#############
zvids="/home/pradmin/Videos/zvids"



########
# Main #
########
for l in "${(@f)"$(<$zvids)"}"; do
    fnumber=$(yt-dlp -F $l | rg "\b720p(\s|$)" | tail -n 1 | cut -f 1 -d ' ')
    yt-dlp -S "res:720,ext:mp4" $l
    #yt-dlp -f "best[height=720][ext=mp4]" $l 

    ## old youtube-dl setup
    # fnumber=$(youtube-dl -F $l | tail -n 1 | cut -f 1 -d ' ')
    # youtube-dl --format $fnumber $l
done

zapfile.sh $zvids

echo "all done"


exit



#########
# Notes #
#########


