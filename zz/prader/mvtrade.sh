#!/usr/bin/env zsh

# mvtrade moves <Screenshot from yyyy-mm-dd hh-mm-ss.png> to
# ~/Documents/oanda_trades/yy-mm-dd_hh-mm-ss_XXXXXX.png
# usage: mvtrade bbbsss | mvtrade aa-analysis-comment

TRADES=/home/pradmin/pradocs/prading/oanda/trades
ANALYSES=/home/pradmin/pradocs/prading/oanda/trades/analyses

ITEM=$1

PNG=$(find ~/Pictures/ -name "Sc*.png")

if [ ${ITEM[1,2]} = 'aa' ];
then
    DIR=$ANALYSES
    FN="$ITEM.png"
else
    DIR=$TRADES
    FN="${PNG[42,49]}_${PNG[51,58]}_$ITEM.png" #new filename
fi

mv $PNG $DIR/$FN
#echo $ITEM $DIR/$FN

exit



