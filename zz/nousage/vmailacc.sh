#!/bin/bash
#   create vmail account for individual
#   usage: vmailacc name@domain password

email=$1
name=${email%@*}
domain=${email#*@}

pswd=$(md5s "$2")

echo $name $domain

echo $email $domain/$name/
echo "postmap /etc/postfix/Vmaps"

echo "$email::5000:5000::/var/mail/vmail/$domain/:/bin/false::"

echo "$email:{PLAIN-MD5}$pswd"

echo $pswd