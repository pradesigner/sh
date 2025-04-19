#!/usr/bin/env bash

# printer out of paper workaround - take out Reason line in /etc/cups/printer.conf
# usage: jri

sudo systemctl stop cups
sudo sed -i '/Reason media-empty-error/d' /etc/cups/printers.conf
sudo systemctl start cups

