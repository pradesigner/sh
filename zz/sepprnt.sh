#!/usr/bin/env bash

# prints separators TODO
# usage: jri but set end..beg

for i in {0003..0001};
do
    printf "            %s\n\f" $i | lp -o cpi=2 -o lpi=2 -o sides=one-sided
done
