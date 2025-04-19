#!/usr/bin/env zsh

#######################################################################
# Gif multiplier                                                      #
#                                                                     #
# AUTH: pradesigner                                                   #
# VDAT: v1 - <2023-07-31 Mon>                                         #
# PURP: Multiplies gifs horizontally.                                 #
#                                                                     #
# gif-hmult.sh produces a horizontal set of the same gif given the    #
# number of tiles. This program is useful for producing the gif image #
# 00.jpg on the tfsite.                                               #
#######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: multiplies gifs horizontally"
    echo "how: gif-hmult.sh <gif file> <number of tiles>"
    echo "see imagemagick in apps.org for explanation"
    exit
fi



#############
# Variables #
#############
file=$1
tiles=$2



########
# Main #
########

# number the files
for ((i = 1; i <= $tiles; i++)); do
    convert $file -coalesce $i-%04d.gif
done

# !!!
for ((i = 1; i < $tiles; i++)); do
    for f in 1-*.gif; do
        convert $f ${f/1/$i} +append $f
    done
done

# !!!
convert -loop 0 -delay 20 1-*.gif result.gif

rm ?-*.gif                      # remove the temporary files



exit



#########
# Notes #
#########

# need to comment !!!
# should test as well !!!
