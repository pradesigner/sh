#!/bin/bash
#rsyncs docs from gom to jornada card


echo "rsync docs to jornada ..."

sudo mount -t msdos /dev/sdb /mnt/jornada
#sudo rsync -a --delete /home/pradmin/docs/ar /mnt/jornada
sudo cp -r /home/pradmin/docs /mnt/jornada
sudo umount /mnt/jornada

echo "all done!"
