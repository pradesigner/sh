#!/usr/bin/env zsh

##########################################################################
# cibc to numbers                                                        #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-07-31 Mon> (created in 2022)                          #
# PURP: change cibc statements to YRMO.pdf                               #
#                                                                        #
# cibc2nums.sh converts the awkward naming of cibc downloaded statements #
# to a rational YRMO.pdf form.                                           #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: converts awkward cibc statements to YRMO.pdf form"
    echo "how: download cibc statements and cibc2nums.sh YR"
    exit
fi



#############
# Variables #
#############
YR=$1                           # provide the year



########
# Main #
########
for f in online*; do            # take each file
    n=${${f#*\(}%\)*}           # parse out the month
    ((n++))
    mv $f $YR$(printf "%02d" $n).pdf # rename the file
done



exit



#########
# Notes #
#########

