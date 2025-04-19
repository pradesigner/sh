#!/usr/bin/env zsh

########################################################################
# git it                                                               #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2023-08-06 Sun>                                          #
# PURP: sets up a git on lentil                                        #
#                                                                      #
# gitit.sh creates a git on lentil inside the gits of the directory it #
# is run from.                                                         #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "NOT USABLE because there is no lentil but could be adapted for alternative."
    echo "use: sets up git repo on lentil of pwd"
    echo "how: gitit.sh clj|default"
    exit
fi



#############
# Variables #
#############
NAME=${PWD##*/}                 # dir name
IGN=$1                          # gitignore file though global takes care of most
ign=".gitignore"

case $IGN in                    # setting up gitignore
    "clj")
        echo "getting clj $ign"
        cp ~/sh/gitstuff/clj$ign $ign
        ;;
    *)
      echo "getting default .gitignore"
      cp ~/sh/gitstuff/def$ign $ign
esac



########
# Main #
########
echo $NAME
ssh lentil rm -rf gits/$NAME.git    # rm old git

git init
git add -A .
git commit -a -m 'initial'
cd ..
git clone --bare $NAME
scp -r $NAME.git lentil:gits/
rm -rf $NAME.git
cd -
git remote add origin lentil:gits/dir.git

echo "all done!"


exit



#########
# Notes #
#########

## doing .gitignore automatically is awkward because we have to search for substring in $PWD
## and getting a number which then has to be used to pick a particular .gitignore
## considering we won't have a lot of variety, it is simpler to just choose it
