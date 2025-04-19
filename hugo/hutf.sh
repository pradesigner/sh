#!/usr/bin/env zsh

######################################################################
# hugo tf                                                            #
#                                                                    #
# AUTH: pradesigner                                                  #
# VDAT: v1 - <2023-08-01 Tue>                                        #
# PURP: Puts tfsite on the server                                    #
#                                                                    #
# hutf.sh can be run from anywhere to build and update the tfsite on #
# lentil. Absolutification indications are given by identifying a    #
# directory (see huhd.sh for more details).                          #
######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: hugo to tf rsync"
    echo "how: jri"
    exit
fi



########
# Main #
########
cd ~/tf

# hugo the site
hugo

# # absolutize the headings for a specific section
# DIR=~/tf/public/ictvity/ethology/fireworks
# find $DIR -name "index.html" ! -path "*/page/*" -exec ~/sh/hugo/huhd.sh "{}" \;

# rsync public with hostinger
rsync -avz --delete --filter 'protect tfold/' -e "ssh -p 65002" public/* u248083646@88.223.85.38:/home/u248083646/domains/towardsfreedom.com/public_html/

# rsync public with lentil
# rsync -av --delete --exclude=file.txt public/* lentil:/srv/http/towardsfreedom.com




exit



#########
# Notes #
#########


# the absolutification can be improved !!!
