#!/usr/bin/env zsh

###########################################################################
# nuzsh script                                                            #
#                                                                         #
# AUTH: pradesigner                                                       #
# VDAT: v1 - <2023-08-14 Mon>                                             #
# PURP: creates a new zsh script                                          #
#                                                                         #
# nuzsh.sh makes a new zsh script using the ~/sh/zshtmpl.sh template. It  #
# copies file to the name provided in the first argument, sets up the     #
# symlnk in bin, opens it in emacs for editing, then exits.               #
###########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: creates new zsh script (default aaa.sh)"
    echo "how: nuzsh.sh [dir/]<name>"
    exit
fi



#############
# Variables #
#############
if [[ -z $1 ]]; then
    name=aaa.sh                 # set a default name to be changed
else
    name=${1%%.*}.sh            # make sure there is only one extension
fi

shdir=~/sh
tmplfile=~/sh/zztmpls/zshtmpl.sh



########
# Main #
########
cd $shdir
cp $tmplfile $name
chmod +x $name
exit
ln -s $(pwd)/$name ~/bin/$name  # make symlnk

emacsclient -c $name &          # spawns bg process



exit



#########
# Notes #
#########

## check link has been correctly made
#ls -l ~/bin/
#vared -p "press enter to continue" -c tmp
