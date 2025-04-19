#!/usr/bin/env zsh

############################################################
# screenshot                                               #
#                                                          #
# AUTH: pradesigner                                        #
# VDAT: v1 - <2020-08-01 Sat>                              #
# PURP: Takes a screenshot                                 #
#                                                          #
# screenshot.sh takes a picture and puts the file into the #
# ~/Pictures/Screenshots directory attaching the datetime  #
# information. The script can be run using the PrtScr key. #
############################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: takes screenshot"
    echo "how: jri with PrtScr"
    exit
fi



#############
# Variables #
#############
screen_dir=~/Pictures/Screenshots/
id=root
filename="`date +%Y-%m-%d_%H:%M:%S`.png"



########
# Main #
########
import -border -window $id "$screen_dir/pic-$filename"



exit



#########
# Notes #
#########


# below is a more complex version that may be worth adapting !!!


######

# #!/bin/bash

# SCREEN_DIR=~/screenshots/
# SCREEN_PROMPT=1

# window='root'

# case $1 in
#   root)
#     window='root';;
#   active)
#     window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d' ' -f5`;;
# esac

# [ ! -z "$SCREEN_PROMPT" ] && \
#   name=`i3-input -P 'screen-name: ' | sed -n '/command = /s/command = //p'`

# if [ -z "$name" ];then
#   if [ $window == "root" ];then
#     name='root'
#   else
#     name=`xprop -id $window | sed -n '/WM_CLASS/s/.* = "\([^\"]*\)".*/\1\n/p'`
#     [ -z "$name" ] && name='window'
#   fi
# fi

# filename="$name-`date +%Y-%m-%d_%H-%M-%S`.png"

# import -border -window $window "$SCREEN_DIR/$filename"


# ln -sf "$filename" $SCREEN_DIR/last

# exit
