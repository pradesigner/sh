#!/bin/sh
# firewall for psinom via iptables
# set for autostart via /etc/init.d/ipfw on 110701

IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe
INT_NET=192.168.0.0/24

# flush existing rules and set chain policy setting to DROP
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP
# load connection-tracking modules
$MODPROBE ip_conntrack
$MODPROBE iptable_nat

### INPUT chain ###
echo "[+] Setting up INPUT chain..."
### state tracking rules
$IPTABLES -A INPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A INPUT -m state --state INVALID -j DROP
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### ACCEPT rules
# Accept all packets from inside
$IPTABLES -A INPUT -i eth0 -j ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT

# External connections
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
### default INPUT LOG rule
$IPTABLES -A INPUT ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options

### OUTPUT chain ###
echo "[+] Setting up OUTPUT chain..."
### state tracking rules
$IPTABLES -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A OUTPUT -m state --state INVALID -j DROP
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ACCEPT rules for allowing connections out
$IPTABLES -A OUTPUT -j ACCEPT

### FORWARD chain ###
$IPTABLES -A FORWARD -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A FORWARD -m state --state INVALID -j DROP
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -j ACCEPT -i venet0

# rules for various services
# DNS
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 53 -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p udp --dport 53 -j ACCEPT

# SSH
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 22 --syn -m state --state NEW -j ACCEPT
# HTTP
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p udp --dport 80  -m state --state NEW -j ACCEPT
# SMTP
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 25 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p udp --dport 465 -m state --state NEW -j ACCEPT
# IMAP
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 220 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p udp --dport 220 -m state --state NEW -j ACCEPT
# POP 3 SSL
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 995 -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p udp --dport 995 -m state --state NEW -j ACCEPT
# SFTP
$IPTABLES -A FORWARD -i eth1 -p tcp --dport 115
# ICMP
$IPTABLES -A FORWARD -i eth1 -p icmp --icmp-type echo-request -j ACCEPT
$IPTABLES -A FORWARD -i eth1 -p icmp --icmp-type echo-reply -j ACCEPT

# Accept only from the internal
$IPTABLES -A FORWARD -i eth0 -s $INT_NET -j ACCEPT

# NAT
$IPTABLES -t nat -A POSTROUTING -s $INT_NET -o eth1 -j MASQUERADE