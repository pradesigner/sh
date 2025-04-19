#!/usr/bin/env zsh

####################################################################
# markdown to orgmode                                              #
#                                                                  #
# AUTH: pradesigner                                                #
# VDAT: v1 - <2022-08-01 Mon>                                      #
# PURP: Convert markdown to orgmode                                #
#                                                                  #
# m2orlinks.sh takes a markdown file and makes it orgmodish in a   #
# simplistic though mostly sufficient way. We cannot recall why we #
# wanted to do this.                                               #
####################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: converts markdown links to orgmode"
    echo "how: m2orlinks.sh <FILE>"
    exit
fi



########
# Main #
########
sed -i -r 's/\[(.+)\]\((.*)\)/[[\2][\1]]/' $1


exit



#########
# Notes #
#########


# unlikely this program will be of much use due to its limited capability.
