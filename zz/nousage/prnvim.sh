#!/bin/bash
# vim print

lp -d nortim -o media=letter -o page-left=36 -o page-top=36 -o prettyprint $1
