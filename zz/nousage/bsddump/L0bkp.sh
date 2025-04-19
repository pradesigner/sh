#!/bin/sh
# serverbkp program dumps to $R:/data/servers/$H
#

# initialize
rc=1
FILESYSTEMS='usr var data'
R=cisnet
H=$(hostname)
H=${H%.*}
level=0

dump -${level}unL -f - / | ssh -i /home/pradmin/.ssh/id_rsa -c blowfish pradmin@$R dd of=/data/servers/$H/Rootdir$level
for FS in $FILESYSTEMS; do
    dump -${level}unL -f - /$FS | ssh -i /home/pradmin/.ssh/id_rsa -c blowfish pradmin@$R dd of=/data/servers/$H/${FS}$level
done

exit $rc
