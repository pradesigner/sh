#!/bin/bash
#   convert maildir to mbox using formail
#   usage: mboxer.sh MB* where MB* are maildirs

for md in MB*; do
    echo "$md being done"
    for f in $md/cur/*; do
	formail < $f >> $md.mbox
    done
done

echo "All done!"
