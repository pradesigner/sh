#!/usr/bin/env zsh

#########################################################################
# recoll indexer                                                        #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2021-08-01 Sun>                                           #
# PURP: Indexes for recoll                                              #
#                                                                       #
# Simply a series of commands to index items in various directories for #
# recoll using the program recollindex. This script should be run every #
# so often to update the database.                                      #
#########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: recollindexer for various directory contents"
    echo "how: jri"
    exit
fi



########
# Main #
########
recollindex
recollindex -c ~/.recoll/ai
recollindex -c ~/.recoll/compsci
recollindex -c ~/.recoll/distec
recollindex -c ~/.recoll/math
recollindex -c ~/.recoll/music
recollindex -c ~/.recoll/nutritionfacts
recollindex -c ~/.recoll/philosophy
recollindex -c ~/.recoll/physics
recollindex -c ~/.recoll/program
recollindex -c ~/.recoll/tax
recollindex -c ~/.recoll/trading
recollindex -c ~/.recoll/zitems


exit



#########
# Notes #
#########




