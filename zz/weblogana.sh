#!/usr/bin/env bash

# weblogana uses analog to produce html pages for virtual domains
# remember to put a ztats dir in each domain
# usage: jri

DOMAINS='ds sla'
VLOGPATH='/psi/var/log/lighttpd/vlogs'
WLAPATH='/psi/var/www'

for D in $DOMAINS; do
    sudo analog $VLOGPATH/$D-access.log -O$WLAPATH/$D/ber/ztats/index.html
    sudo chown pradmin:pradmin $WLAPATH/$D/ber/ztats/*
done
