#!/usr/bin/env zsh

##########################################################################
# Copy Scores                                                            #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-07-31 Mon>                                            #
# PURP: Copy scores to sd card.                                          #
#                                                                        #
# cpscore.sh copies praductions scores into a folder on sd card so these #
# pdfs are easy to access on a tablet and serve as electronic            #
# sheetmusic. Use lsblk to determine <DEVICE>.                           #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: copies scores from praductions to sd cards for tablets"
    echo "how: jri and input sdXN"
    exit
fi



#############
# Variables #
#############
lsblk
vared -p "Input the device (sdXN): " -c dev
echo $dev



########
# Main #
########
sudo mount /dev/$dev /home/mnts/sd   # mount the sd card

# find all scores and copy to sd card
for f in $(find ~/praductions/ -name "vscore.pdf"); do
    sudo cp $f /home/mnts/sd/scores/${${f%/*}##*/}.pdf
done

sudo umount /home/mnts/sd       # umount

echo "files copied and sd unmounted"


exit



#########
# Notes #
#########

