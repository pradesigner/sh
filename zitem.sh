#!/usr/bin/env zsh

#########################################################################
# zitems                                                                #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2021-08-01 Sun>                                           #
# PURP: Pocket items to zitems                                          #
#                                                                       #
# zitem.sh takes downloaded pocket mhtml files and puts them into the   #
# zitems directory. Then recollindex is run on that directory to update #
# the database. This system provides an effective means of organizing   #
# knowledge since pocket can get articles to our computer easily and    #
# recoll can access it via keywords and phrases.                        #
#########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: places pocket downloads into zitems folder"
    echo "how: jri"
    exit
fi



########
# Main #
########
cd ~/dd/

# move all pocket downloads into zitems directory
for f in Pocket*; do
    mv $f ~/ocs/ucate/zitems/${f##*Pocket - }
done

# index the directory
recollindex -c ~/.recoll/zitems/



exit



#########
# Notes #
#########



#TODO make so it can do more than just pocket? !!!


