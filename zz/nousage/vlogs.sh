#!/usr/local/bin/zsh
# vlog turnover

HOMEDIR=/home/pradmin
LOGDIR=/var/log/lighttpd/vlogs
OLDvlogs=vlogs$(date "+%Y-%m")

/usr/local/etc/rc.d/lighttpd stop
mv $LOGDIR $HOMEDIR/vlogs
mkdir $LOGDIR
chown www:www $LOGDIR
/usr/local/etc/rc.d/lighttpd start

echo tarring the logs
tar zcf $HOMEDIR/vlogsgz/$OLDvlogs.tar.gz $HOMEDIR/vlogs

echo perform stats
/home/pradmin/bin/poohecount.sh

echo removing vlogs dir
rm -r $HOMEDIR/vlogs

echo sending confirmation email
msg='All rotated now'
echo $msg | mail -u pradmin -s "Lighttpd Logs Rotated" prad@towardsfreedom.com
echo done!
