#!/usr/bin/env zsh

arch ini setup

AUTH: pradesigner
VDAT: v1 - 2023-12-25
PURP: wifi, sshd, and passwd setups

archini.sh creates the wifi connection, starts the sshd daemon, and sets the root passwd.


########
# Help #
########
if [[  == '-h' ]]; then
    echo "use: wifi, sshd, passwd setups"
    echo "how: jri"
    exit
fi



#############
# Variables #
#############
pp="thetplink_pa$$"
dv="wlan0" #usually
ss="TP-Link_BEE4"
ps="m"

########
# Main #
########
# connect to wifi
iwctl --passphrase=$pp station $dv connect $ss

# set password
echo -e "$ps\n$ps" | passwd root

# start sshd
systemctl start sshd

exit



#########
# Notes #
#########
