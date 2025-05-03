#!/usr/bin/env zsh

###########################################################################
# zotrec                                                                  #
#                                                                         #
# AUTH: pradesigner with pp                                               #
# VDAT: v1 - <2025-05-03 Sat>                                             #
# PURP: bring zotrec to workspace                                         #
#                                                                         #
# zotrec.sh moves the minimized zotrec applications to current workspace. #
###########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: brings zotero and recoll to current workspace"
    echo "how: jri with meta-f1"
    exit
fi



#############
# Variables #
#############
# Get the current workspace number (starts at 0)
current_workspace=$(wmctrl -d | awk '/\*/ {print $1}')



########
# Main #
########
# Move Zotero window to current workspace
wmctrl -x -r zotero -t $current_workspace
wmctrl -x -r recoll -t $current_workspace
# Activate (focus) the Zotero window
wmctrl -x -a zotero
wmctrl -x -a recoll


exit



#########
# Notes #
#########
