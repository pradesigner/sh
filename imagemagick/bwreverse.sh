#!/usr/bin/env zsh

##########################################################################
# bw reversal                                                            #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2020-08-02 Sun>                                            #
# PURP: reverses black and white                                         #
#                                                                        #
# bwreverse.sh reverses black and white using imagemagick and is useful  #
# for removing black backgrounds which would be quite strenous to print. #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: reverse bw to remove black background"
    echo "how: bwreverse.sh image.png"
    exit
fi



#############
# Variables #
#############
IMG=$1



########
# Main #
########
convert $IMG -colorspace HSB -channel g -separate +channel -threshold 0% mask

convert $IMG \( -clone 0 -negate \) \( -clone 0 -colorspace HSB -channel g -separate +channel -threshold 0% -negate \) -compose over -composite $IMG

convert $IMG -white-threshold 90% -fill white $IMG

rm mask

convert $IMG pdf:- | lp -d grazia -o landscape -o fit-to-page



exit



#########
# Notes #
#########


