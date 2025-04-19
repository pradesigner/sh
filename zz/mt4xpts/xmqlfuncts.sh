#!/usr/bin/env bash

# xtracts mql words from
# https://docs.mql4.com/function_indices
# and
# https://docs.mql4.com/constant_indices
# usage: jri

cat mqlfuncts.html | grep -G '.*190.*topiclink.*' | sed -r 's/<.*>(.+)<\/a>.*/\1/' | tr '\n' ' '

exit
