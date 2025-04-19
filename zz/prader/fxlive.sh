#!/usr/bin/sh

# fxlive runs oanda fxTrade live version
# usage: jri

# get password
pass -c oanda.com/theprader

# in gnome though the fxTrade is in the location show below
java -jar -Xmx512m -Dsun.java2d.d3d=false /home/pradmin/.oanda/jar/fxTrade/fxTrade


exit
