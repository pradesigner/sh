#!/usr/bin/env zsh

###################################################################
# recoll setup                                                    #
#                                                                 #
# AUTH: pradesigner                                               #
# VDAT: v1 - <2021-08-01 Sun>                                     #
# PURP: Sets up recoll index.                                     #
#                                                                 #
# recoll-new-index.sh sets up a directory for indexing by recoll. #
###################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: recoll index setup"
    echo "how: recoll-new-index.sh indxnam targdir"
    exit
fi



#############
# Variables #
#############
indxnam=$1                      # name index
targdir=$2                      # identify dir

indxdir=~/.recoll/$indxnam      # set it up in recoll dir



########
# Main #
########
mkdir $indxdir 

# create recoll.conf in dir and make index
echo "topdirs=$targdir" > $indxdir/recoll.conf
recollindex -c $indxdir


exit



#########
# Notes #
#########


