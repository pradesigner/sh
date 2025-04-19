#!/usr/bin/env bash

# syncs files between mt4 and dropbox
# usage: jri

templates="$HOME/questrade/templates"
db_templates="$HOME/Dropbox/mt/templates"

scripts="$HOME/questrade/MQL4/Scripts"
db_scripts="$HOME/Dropbox/mt/Scripts"

experts="$HOME/questrade/MQL4/Experts"
db_experts="$HOME/Dropbox/mt/Experts"

if [ $HOSTNAME == novo ]
then
    rsync -av --delete "$templates/" "$db_templates/"
    rsync -av --delete "$scripts/" "$db_scripts/"
    rsync -av --delete "$experts/" "$db_experts/"
fi

if [ $HOSTNAME == galliumos ]
then
    rsync -av --delete "$db_templates/" "$templates/"
    rsync -av --delete "$db_scripts/" "$scripts/"
    rsync -av --delete "$db_experts/" "$experts/"
fi

exit
