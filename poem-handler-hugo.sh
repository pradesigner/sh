#!/usr/bin/env zsh

#########################################################################
# orgmode-hugo poem                                                     #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2022-08-01 Mon>                                           #
# PURP: Formats poems for hugo.                                         #
#                                                                       #
# poem-handler-hugo.sh gets poems looking correct from orgmode files    #
# when hugo converts them to html. The verse feature in orgmode did not #
# do a sufficiently good job. This program was largely created because  #
# Angel had a lot of poems for the tfsite.                              #
#########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: orgifies poetry for hugo"
    echo "how: poem-handler-hugo.sh <FILE>"
    exit
fi



########
# Main #
########
head -n 10 $1 > TMP #skip the first 10 lines which are frontmatter
p2=$(tail -n +11 $1)

## this works!
echo $p2 |\
    awk 'BEGIN {RS="\n"; ORS="@"} {print}' |\
    sed -e 's/@@/\n\n/g' -e 's/@/\\\\\n/g' >> TMP

cp TMP $1
rm TMP


exit



#########
# Notes #
#########


# we were also expt so revisit this and use perl !!!

## do it with just awk - ???
# echo $p2 |\
#     awk 'BEGIN {RS="\n"; ORS="@"} {print}' |\
#     awk 'BEGIN {RS="\n"}{sub("@@","\n\n",$0); print}' |\
#     >> TMP

## awk and tr doesn't work for multiple tr substitutions
# echo $p2 |\
#     awk 'BEGIN {RS="\n"; ORS="@"} {print}' |\
#     tr "@@" "\n\n" |\
#     tr "@" "\\\\\n" |\
#     >> TMP

