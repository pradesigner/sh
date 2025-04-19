#!/usr/bin/env zsh

########################################################################
# orgmode heading numbering                                            #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2023-08-01 Tue>                                          #
# PURP: numbers orgmode headings.                                      #
#                                                                      #
# orgnum.sh can (un)number headings which are usually have no cardinal #
# value at any depth. This script produces numbered headings which are #
# often desired for various reasons.                                   #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: (un)numbers the headings"
    echo "how: org-numberer.sh <FILE>.org [(-)+]"
    exit
fi



#############
# Variables #
#############
fn=$1                           # filename
op=$2                           # operation [+-] numbers
h=(0 0 0 0 0 0)                 # initialize heading array to depth of 6



########
# Main #
########
case $op in
    
    "+")                        # number
        echo "adding numbering ..."
        while read l
        do
            itm=${l%% *}       # isolate the itm before the first space
            len=${#itm}        # get length of the itm
            txt=${l#* }        # isolate the text following *

            if [[ $itm =~ ^\\* ]];
            then # if itm begins with * it is a heading, so process numbering
                (( h[len]++ ))

                # build the section numbers sn
                sn=''
                for i in {1..$len};do
                    sn="$sn$h[i]."
                done
                sn=${sn%.}
                h[i+1]=0
                l="$itm $sn $txt"
            fi

            echo $l >> TMP    # append line (heading or not)to TMP file
            
        done < $fn
        mv TMP $fn
        ;;
    
    "-")                        # unnumber
        echo "removing numbering ..."
        sed -i 's/^\(\**\) [0-9.]* /\1 /' $fn
        ;;

    *)
        echo "LIKE THIS: orgnum.sh <FILE>.org [+-]"
        exit
        
esac


exit



#########
# Notes #
#########









    

exit
