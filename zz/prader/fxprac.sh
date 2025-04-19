#!/usr/bin/sh

# fxprac runs oanda fxTrade demo version
# usage: jri

# get password
pass -c oanda.com/theprader

# in gnome though the fxTradePractice is in the location show below
java -jar -Xmx512m -Dsun.java2d.d3d=false /home/pradmin/.oanda/jar/fxTradePractice/fxTradePractice

exit

# how it was on lxde:
# note that fxTradePractice.desktop is a Desktop file and needs to be in .local/share/applications/
# gtk-launch fxTrade
