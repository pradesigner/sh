#!/bin/bash
# set up vmail for system
#

#directory initializations
postfixD='/etc/postfix/'
vmailD='/var/spool/vmail/'
f1='Vmaps'
Vmaps=$postfixD$f1

echo $Vmaps
echo $vmailD

# set up the vmail directories if they don't exist
for each in $(awk -F' ' '{print $2}' $Vmaps)
do
	VdomainD=$vmailD$each
	cur=$VdomainD'cur'
	new=$VdomainD'new'
	tmp=$VdomainD'tmp'
	
	print $cur
	print $new
	print $tmp
	
	if [ ! -d $VdomainD ]; then
		mkdir -p $VdomainD
		mkdir $cur $new $tmp
		chmod 700 $VdomainD/*
	fi
done

#make all ownership virtual:virtual
#comment out the first three after first use
mkdir /var/virtual
groupadd -g 5000 virtual
useradd -g 5000 -u 5000 -s /sbin/nologin -d /var/virtual virtual
chown -R virtual:virtual $vmailD

echo 'directories all setup with permissions'
echo 'virtual group and user added'
echo 'ownership of vmail changed to virtual'

exit
