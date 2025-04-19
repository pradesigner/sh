#!/usr/bin/env zsh

#########################################################################
# notpdf removal                                                        #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2023-08-01 Sat>                                           #
# PURP: Removes not pdf                                                 #
#                                                                       #
# notpdf-rm.sh removes files that are not pdf. Exactly why we wanted to #
# do this has been forgotten, but it likely was useful for something at #
# sometime. A simple find command can likely do the job more simply.    #
#########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: removes files which aren't pdfs"
    echo "how: notpdf-rm.sh <file>"
    exit
fi



#############
# Variables #
#############
ftype=$(file $1)                # can show PDF|data



########
# Main #
########
if [[ -f $1 && ! $ftype =~ "PDF|data" ]]
then
    echo "removing ${ftype%:*}"
    rm $1
fi



exit



#########
# Notes #
#########


# do it with a find command sometime !!!
