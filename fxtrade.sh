#!/usr/bin/env zsh

###################################################
# fxtrade                                         #
#                                                 #
# AUTH: pradesigner                               #
# VDAT: v1 - <2024-03-09 Sat>                     #
# PURP: Starts oanda fxtrade                      #
#                                                 #
# Launches the fxtrade program for oanda trading. #
###################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: run fxtrade for oanda"
    echo "how: jri"
    exit
fi



########
# Main #
########
java -jar -Xmx512m -Dsun.java2d.d3d=false /home/pradmin/.oanda/jar/fxTrade/fxTrade



exit



#########
# Notes #
#########
every now and then may need to download fxtrade-installer.sh
when prompted to get the latest version.
