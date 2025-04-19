#!/usr/bin/env bash

# simple post finder
# usage: postfind "regexp"

PFFN="/home/pradmin/myposts/pftmp.html"
COLS="'<b>' || pky || ' ' || url || '</b>' || '<br>' || txt || '<br><br>'"

sqlite3  ~/myposts/myposts.db "select $COLS from posts where txt like '%$1%';" | sed 's/<p>.<\/p>//g' | txt2html --noec --utf8 > $PFFN

firefox $PFFN
