#!/usr/bin/env zsh
# extracts portion of file given delimiters

for IF in *.php
do
  OF=${IF%%.*}.inc
  TF=$OF.tmp
  awk '/--Content begins here--/,/--Content ends here--/' $IF > $OF
  sed s/'<!--Content begins here-->'// $OF > $TF
  sed s/'<!--Content ends here-->'// $TF > $OF
  echo $IF to $OF
done
