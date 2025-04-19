#!/usr/bin/env zsh

#########################################################################
# hugo new page                                                         #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2023-08-01 Tue>                                           #
# PURP: Create new hugo page                                            #
#                                                                       #
# nuhu.sh creates a new page for a hugo website and is run from         #
# .../hugos/<site>. The page location is established by                 #
# content/<whatever>/.../[_] depending on whether we want a single page #
# or a list. The new page index.org is opened in emacs for editing.     #
#########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: creates a new [_]index.org file utilizing directory structure"
    echo "how: run from hugos/SITE/, nuhu.sh content/WHATEVER/../[_]"
    exit
fi



#############
# Variables #
#############
#ITM=${(L)@##*/} ? !!!
F0=$@
F1=${(L)F0// /-}
FI=${F1#*/}index.md



########
# Main #
########
hugo new $FI

emacsclient -c "content/$FI" &  # spawns bg process



exit



#########
# Notes #
#########


# works well and likely does not require much improvement.
