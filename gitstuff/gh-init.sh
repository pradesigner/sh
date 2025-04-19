#!/usr/bin/env zsh

##########################################################################
# github init setup                                                      #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v2 - <2025-01-29 Tue>                                            #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Sets up repo on github                                           #
#                                                                        #
# gh-init.sh sets up a github repository of the directory the program is #
# run from. All parameters are handled including the initial push. The   #
# repo name is that of the directory.                                    #
##########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: initial push onto github using dirname as reponame"
    echo "how: cd <dir> then gh-init.sh pub|pri"
    exit
fi



#############
# Variables #
#############
NAME=${PWD##*/}

case $1 in
    pri)
        pripub=private
        ;;
    pub)
        pripub=public
        ;;
    *)
        echo "argument must be pub|pri"
        exit
esac



########
# Main #
########
git init
git add .
git commit -m "Initial commit: Add base files"
git branch -M main
gh repo create pradesigner/$NAME --"$pripub" --source=. --remote=origin
git push -u origin main

echo "DONE"

exit



#########
# Notes #
#########


# works perfectly
