#!/usr/bin/env zsh
#counts hits by date ??

for d in {1..31};do
thedate='0'$d
p=$thedate[-2,3]/$2/
echo $p `grep -c $p /var/log/lighttpd/vlogs/$1-access.log`
done
