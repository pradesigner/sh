#!/usr/bin/env zsh

#########################################################################
# notmuch utility                                                       #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2020-08-01 Sat>                                           #
# PURP: Handles various notmuch tasks.                                  #
#                                                                       #
# nmprg.sh is run as nmp c|f|t|p and fetches and trashes email within   #
# the maildir format. The fetching is done through fdm and trashing is  #
# simply moving marked mail into a trash directory which can be deleted #
# whenever. The notmuch database is also updated.                       #
#########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: handles notmuch emails"
    echo "how: nmp c|f|t|p"
    echo "     - c,f fetches mail removes from, leaves on server"
    echo "     - t moves trash to ~/.trash"
    echo "     - p polls server"
    exit
fi



#############
# Variables #
#############
ch=$1                           # make the choice



########
# Main #
########
case $ch in
    f)                          # gets emails but leaves on server
        fetchmail -k
        ;;
    c)                          # gets emails and removes from server
        fetchmail
        ;;
    p)                          # polls servers
        fetchmail -c
        ;;
    t)                          # move emails to trash
        mv $(notmuch search --output=files --exclude=false tag:trash) ~/.trash
        ;;
    *)
        echo 'usage: nmprg.sh f|c|p|t'
        ;;

esac

notmuch new                     # update notmuch db



exit



#########
# Notes #
#########






exit

