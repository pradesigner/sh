#!/usr/bin/env zsh

########################################################################
# file numberer                                                        #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2020-07-31 Fri>                                          #
# PURP: Numbers files sequentially.                                    #
#                                                                      #
# Gets files in a directory recursively, and sequentially numbers them #
# to a new directory at same level.                                    #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: Grabs files recursively, copies sequentially numbered to newdir"
    echo "how: filenumberer.sh <newdir> (beside dir where files are)"
    exit
fi



#############
# Variables #
#############
if [[ -z $1 ]]; then
    echo "Enter dir for files, eh!!"
    exit
fi

newdir=$1                       # set newdir provided it is given



########
# Main #
########
mkdir ../$newdir

k=0
find . -type f |
    while read f;
    do
        k=$(($k+1))
        cp $f ../$newdir/${(l(5)(0))k}.pdf
    done



exit



#########
# Notes #
#########


# there are likely more efficient ways of doing this through zsh parameters!!!
