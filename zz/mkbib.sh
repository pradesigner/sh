#!/usr/bin/env bash

# mkbib.sh recurses into each directory and runs cb2bib -doc2bib *.pdf the.bib
# usage: just run it

#make separator a \n
IFS='
'

#create array based on \n separator
f=$(find ./* -type d)

for e in $f;do
    cd $e
    cb2bib --doc2bib *.pdf the.bib
    cd -
done
