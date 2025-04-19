#!/usr/bin/env zsh

#########################################################################
# hugo headlines absolutification                                       #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2023-08-01 Tue>                                           #
# PURP: Absolutifies orgmode headlines                                  #
#                                                                       #
# huhd.sh absolutifies headlines for hugo generated html and is not run #
# on its own. It is automatically called by hutf.sh on files of a       #
# particular directory. Presently the directory is inserted into the    #
# hutf.sh script, but an improvement would be to have it indicated in   #
# the frontmatter.                                                      #
#                                                                       #
# mechanism:                                                            #
# take all #headline-x                                                  #
# replace it with the actual headline wording (spaces -> -)             #
#                                                                       #
# example:                                                              #
# <li><a href="#headline-1">Structure of Site</a>                       #
# becomes                                                               #
# <li><a href="#Structure-of-Site">Structure of Site</a>                #
#                                                                       #
# This absolutification was created because inserting other headlines   #
# changed the sequence altering all urls below the inserted item. While #
# there are some advantages to having it so, any links to changed urls  #
# would not take one to the correct place.                              #
#########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: absolutifies headlines"
    echo "how: jri via hutf.sh"
    exit
fi



#############
# Variables #
#############
# for the file
F=$1

# grab all the #headline-x and its description then split into array on \n
str=$(perl -ne 'print "$1|$2\n" if /<li><a href="(#headline-\d+)">(.+)<\/a>/' $F)
lines=(${(f)str})

# using assoc array (only because i've never tried it before)
declare -A aa



########
# Main #
########
for l in $lines; do
    # split into assoc array
    aa=(${(s:|:)l})
    key=${${(k)aa}#\#} #rm the '#' symbol
    val=${(v)aa} 
    lnk=${val// /-} #replace sp with -

    #echo "$key -> $val -> $lnk"

    # do the replacements
    perl -pi -e "s/$key/$lnk/g" $F
done



exit



#########
# Notes #
#########


# improve by indicating absolutification in the frontmatter
