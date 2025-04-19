#!/usr/bin/env zsh

#######################################################################
# lilypond version update                                             #
#                                                                     #
# AUTH: pradesigner                                                   #
# VDAT: v1 - <2024-05-11 Sat>                                         #
# PURP: Update all lilypond files to current version.                 #
#                                                                     #
# lyvupdate.sh finds all lilypond *.ly files recursively in the       #
# praductions directory and updates them to the current version using #
# supplied convert-ly file.                                           #
#######################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: update *.ly files in praductions/"
    echo "how: jri"
    exit
fi



#############
# Variables #
#############
praductions=~/ocs/agio/praductions


#############
# Functions #
#############
bkppraductions() {              # tars directory without ancestors with present date
    echo "backing up praductions directory to ~/Documents/bkps"
    tar -cf ~/Documents/bkps/praductions-$(date +%Y-%m-%d).tar -C ~/ocs/agio praductions
}



########
# Main #
########
bkppraductions

for f in $(find $praductions -name "*.ly"); do
    convert-ly -e $f            # makes the version change
    #run the part producer

done


exit



#########
# Notes #
#########
# not putting in parents because doing so from the wrong place creates nested directories.
