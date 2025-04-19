#!/usr/bin/env bash

# xtracts mql words from
# https://docs.mql4.com/function_indices
# and
# https://docs.mql4.com/constant_indices
# usage: jri


cat mqlconsts.html | grep -G '255px.*<p class="p_fortable"><span class="f_fortable">.*</span></p>' | sed -r 's/<.*>(.+)<\/span>.*/\1/' | tr '\n' ' '
