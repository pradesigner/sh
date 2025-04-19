#!/usr/bin/env zsh

########################################################################################
# nnn wrapper                                                                          #
#                                                                                      #
# AUTH: pradesigner                                                                    #
# VDAT: v1 - <2023-08-12 Sat>                                                          #
# PURP: wraps nnn for env vars                                                         #
#                                                                                      #
# nnn has issues running from gnome-terminal unless wrapped to load required env vars. #
########################################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: launches env var loaded nnn"
    echo "how: jri via leftwm key"
    exit
fi


#############
# Variables #
#############
source ~/.zsh.d/nnn



########
# Main #
########
EDITOR=mg gnome-terminal -- nnn -o



exit



#########
# Notes #
#########

## Variables and functions are kept in .zsh.d/nnn so that these are
## accessible either from inside gnome-terminal directly or through
## leftwm. Additionally, all data content is thus kept in the same
## file instead of in 2 separate ones.
