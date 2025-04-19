#!/usr/bin/env bash

# starts up various programs
# usage: jri or autostart

# sets the keyboard map
setxkbmap dvorak

# starts musescore
#musescore.sh

# sets up the tunnel
autossh -f -M 0 -nNT -R 10022:localhost:22 184.69.125.162

exit