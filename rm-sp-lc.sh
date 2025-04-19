#!/usr/bin/env zsh

##########################################################################
# filename spaceless-lowercase                                           #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Remove spaces and lowercase                                      #
#                                                                        #
# rm-sp-lc.sh replaces spaces with hypens and lowercases all letters     #
# from filenames making them more convenient to work with. We tend to    #
# standardize all filenames along these lines whenever it is sensible to #
# do so.                                                                 #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: for a file remove spaces and make lower case"
    echo "how: rmsplc.sh *.ext"
    exit
fi



########
# Main #
########
for e in "$@"; do # $@ must be in quotes to handle spaces in filenames
    f=$(echo $e | tr -d " " | tr "A-Z" "a-z")
    mv "$e" "$f"
done



exit



#########
# Notes #
#########


# there are likely better ways of doing this renaming now that we have zmv working !!!






