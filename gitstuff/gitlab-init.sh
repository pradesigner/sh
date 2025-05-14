#!/usr/bin/env zsh

##########################################################################
# gitlab repo setup                                                      #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Sets up a gitlab repo                                            #
#                                                                        #
# gitlab-init.sh sets up a gitlab repo of the directory it is run        #
# from. The repo takes on the name of the directory. Since we do not use #
# gitlab much partly due to its irritations, we likely will not use this #
# script too often.                                                      #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: setup gitlab repo"
    echo "how: cd <dir> then jri"
    exit
fi



#############
# Variables #
#############
NAME=${PWD##*/}



########
# Main #
########
git init
git remote add origin git@gitlab.com:pradtf/$NAME.git
git add .
git commit -m "Initial commit"
git push -u origin master

echo "DONE"



exit



#########
# Notes #
#########


# works but we likely won't be using gitlab much
