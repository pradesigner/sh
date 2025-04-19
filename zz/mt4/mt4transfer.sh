#!/usr/bin/env bash

# syncs templates, Experts, Scripts from novo to lentil tf
# usage: jri


templates="$HOME/.wine/drive_c/Program Files/Questrade MetaTrader/templates"
tf_templates="/srv/websites/towardsfreedom.com/ber/zz/mt4/templates"

scripts="$HOME/.wine/drive_c/Program Files/Questrade MetaTrader/MQL4/Scripts"
tf_scripts="/srv/websites/towardsfreedom.com/ber/zz/mt4/Scripts"

experts="$HOME/.wine/drive_c/Program Files/Questrade MetaTrader/MQL4/Experts"
tf_experts="/srv/websites/towardsfreedom.com/ber/zz/mt4/Experts"

tfmt4="towardsfreedom.com/zz/mt4"

if [ $HOSTNAME == novo ]
then
    rsync -av --delete "$templates/" lentil:"$tf_templates"
    rsync -av --delete "$scripts/" lentil:"$tf_scripts"
    rsync -av --delete "$experts/" lentil:"$tf_experts"
elif [ $HOSTNAME == galliumos ]
then
    wget -r -l1 -nH --cut-dirs=3 --no-parent --reject="index.html*" $tfmt4/templates/ -P "$templates/"
    wget -r -l1 -nH --cut-dirs=3 --no-parent --reject="index.html*" $tfmt4/Scripts/ -P "$scripts/"
    wget -r -l1 -nH --cut-dirs=3 --no-parent --reject="index.html*" $tfmt4/Experts/ -P "$experts/"
fi

exit
