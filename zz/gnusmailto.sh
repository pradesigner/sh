#!/usr/bin/env bash

# emacs-mailto-handler

mailto=$1
mailto="mailto:${mailto#mailto:}"
mailto=$(printf '%s\n' "$mailto" | sed -e 's/[\"]/\\&/g')
elisp_expr="(mailto-compose-mail \"$mailto\")"

#emacsclient -a "" -c -n --eval "$elisp_expr" \
#	'(set-window-dedicated-p (selected-window) t)'

mail $mailto
