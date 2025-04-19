#!/usr/bin/env zsh

##########################################################################
# collage it                                                             #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-02 Wed>                                            #
# PURP: Makes collage from individual images                             #
#                                                                        #
# collageit.sh takes individual images and puts them together using      #
# imagemagick montage feature. The script was originally created to make #
# the logo display in the Helpful Alliances section on ffsite. The       #
# original version sets an image size and a width of how many images     #
# across. Improvements would allow greater control on how images are put #
# together.                                                              #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: creates a collage from individual logos"
    echo "how: collage.sh <DIR CONTAINING LOGOS> <FILENAME OF MONTAGE>"
    exit
fi




#############
# Variables #
#############
# if no dir, then helpful-alliances by default
if [[ -z $1 ]]; then
    DIR=~/tf/content/ictvity/ethology/fireworks/helpful-alliances
else
    DIR=$1
fi

cd $DIR

# if no file, then 00.jpg
if [[ -z $2 ]]; then
    FILE=00.jpg
else
    FILE=$2
fi



########
# Main #
########
rm $FILE #remove existing collage

files=( logo-*.(png|jpg) ) #list files in array
NUM=$#files #give arraysize which is number of files

# logo dimensions and border
DIM='99x55>+2+2'

# rowcol calculation ROW x COL > NUM
MOD=6

if [[ $(( NUM % MOD )) -eq 0 ]]; then #if remainder is 0
       RINC=0;
   else
       RINC=1;
fi


ROW=$(( NUM/MOD + RINC ))
COL=$(( NUM/ROW ))

if [ $(( ROW * COL )) -lt $NUM ]; then
    $((COL++));
fi


echo $ROW,$COL
magick montage -geometry $DIM -tile $ROWx$COL *.{jpg,png} 00.jpg

echo "All done!"



exit



#########
# Notes #
#########







rm $FILE #remove existing collage

files=( logo-*.(png|jpg) ) #list files in array
NUM=$#files #give arraysize which is number of files

# logo dimensions and border
DIM='99x55>+2+2'

# rowcol calculation ROW x COL > NUM
MOD=6

if [[ $(( NUM % MOD )) -eq 0 ]]; then #if remainder is 0
       RINC=0;
   else
       RINC=1;
fi


ROW=$(( NUM/MOD + RINC ))
COL=$(( NUM/ROW ))

if [ $(( ROW * COL )) -lt $NUM ]; then
    $((COL++));
fi


echo $ROW,$COL
magick montage -geometry $DIM -tile $ROWx$COL *.{jpg,png} 00.jpg

exit
