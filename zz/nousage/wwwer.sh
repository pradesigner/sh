#!/bin/sh
# take me to your website

HTDOCS=/vhost/www/

case $1 in
    huraw|ycc|chdc|fcs|inanykey|kelele|tslw|tf|tracs|ll)
    HOST=plexus
    ;;
esac

echo $HOST

cd $HTDOCS/$1/ber
emacs &

lftp -u pradmin,Sanotehu sftp://$HOST -e "cd $1"

				 
