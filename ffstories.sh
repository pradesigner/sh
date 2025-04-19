#!/usr/bin/env zsh

######################################################################
# ffstories                                                          #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-04-31 Sun>                                        #
# PURP: Grab stories submitted for ffsite.                           #
#                                                                    #
# Downloads the file.txt from fireworks/stories/ for addition to the #
# index.org page. The original file.txt is also cleared.             #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: gets file.txt from fireworks stories and resets"
    echo "how: jri"
    exit
fi



########
# Main #
########

# goto stories dir
cd ~/tf/content/ictvity/ethology/fireworks/stories

# download file.txt
scp lentil:/srv/http/towardsfreedom.com/ictvity/ethology/fireworks/stories/file.txt .

# clear file.txt on lentil
ssh lentil "cat /dev/null > /srv/http/towardsfreedom.com/ictvity/ethology/fireworks/stories/file.txt"

# show file.txt
cat file.txt



exit



#########
# Notes #
#########

