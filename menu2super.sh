#!/usr/bin/env zsh

##########################################################################
# menukey to Super_R                                                     #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Mon>                                            #
# PURP: Makes the menukey to Super_R.                                    #
#                                                                        #
# This oneliner is useful on laptops which do not have a Super_R         #
# key. This is the situation for most laptops keyboards and since we set #
# an xmodmap we cannot alter keycodes afterwards within the xinitrc      #
# file. This program or the oneliner should be run upon each reboot,     #
# though if we hibernate the laptop it will not be done as often.        #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: changes Menu key to Super_R"
    echo "how: jri"
    exit
fi



########
# Main #
########
xmodmap -e "keycode 135 = Super_R"



exit



#########
# Notes #
#########



