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
    echo "use: recollindexer for all recoll directory contents, full flag renews"
    echo "how: recoll-indexer.sh [full]"
    exit
fi



#############
# Variables #
#############
if [[ "$1" == "full" ]]; then
    OPT="-z"
else
    OPT=""
fi

DIRS=(ai compsci distec math music nutritionfacts philosophy physics pp program tax trading zitems)



########
# Main #
########

for d in $DIRS; do
    echo "=== INDEXING $d $OPT ==="
    recollindex -c ~/.recoll/$d $OPT #-m -v 2>&1 | tee ~/recoll-$d.log
done


exit



#########
# Notes #
#########




