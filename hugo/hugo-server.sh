#!/usr/bin/env zsh

################################################################
# Hugo Server                                                  #
#                                                              #
# AUTH: pradesigner                                            #
# VDAT: v1 - <2023-11-07 Tue>                                  #
# PURP: Runs hugo server in background                         #
#                                                              #
# The hugo server is started without using an active terminal. #
################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: runs the hugo server from dir $1"
    echo "how: hugo-server.sh <dir>"
    exit
fi



#############
# Variables #
#############
DIR=$1                          # directory of the site (eg tf)



########
# Main #
########
cd $DIR
hugo server


exit



#########
# Notes #
#########

not required since switching to tumbleweed as kde autostart runs it.
