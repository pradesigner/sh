#!/usr/bin/env zsh

######################################################################
# syncer                                                             #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2022-08-01 Mon>                                        #
# PURP: Syncs dirs between computers.                                #
#                                                                    #
# syncer.sh uses rsync to synchronize directories between computers. #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: rsyncs a dir between computers"
    echo "how: syncer.sh <computer:> <dirpath> "
    exit
fi



#############
# Variables #
#############
if [[ ${1: -1} != "/" ]]; then
    COM=$1/
else
    COM=$1
fi

if [[ ${2: -1} != ":" ]]; then
    DIR=$2:
else
    DIR=$2
fi



########
# Main #
########
rsync -av $DIR $COM$DIR



exit



#########
# Notes #
#########


# should re-examine and improve !!!
