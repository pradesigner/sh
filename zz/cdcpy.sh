#!/usr/bin/env zsh

######################################################################
# cd copy                                                            #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-07-31 Mon>                                        #
# PURP: Copies a cd.                                                 #
#                                                                    #
# cdcpy.sh duplicates a cd by making an iso and then burning it with #
# wodim which needs to be installed.                                 #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: copies cd by making iso and burning it using wodim"
    echo "how: jri"
    exit
fi



########
# Main #
########
dd if=/dev/cdrom of=cd.iso      # create the iso

sudo wodim cd.iso               # burn the cd



exit



#########
# Notes #
#########
