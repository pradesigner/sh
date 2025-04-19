#!/usr/bin/env bash

# gets tickdata from truefx
# usage: jri

#http://www.truefx.com/dev/data/2017/JANUARY-2017/AUDJPY-2017-01.zip

base=http://www.truefx.com/dev/data

fn=$pr-$yr-$mn.zip

url=$base/$yr/$mo-$yr/$fn

#yrs=(2016 2015 2014 2013 2012 2011)
yrs=(2018)
mos=(JANUARY FEBRUARY MARCH APRIL MAY JUNE JULY AUGUST SEPTEMBER OCTOBER NOVEMBER DECEMBER)
mns=(01 02 03 04 05 06 07 08 09 10 11 12)
prs=(AUDJPY AUDNZD AUDUSD CADJPY CHFJPY EURCHF EURGBP EURJPY EURUSD GBPJPY GBPUSD NZDUSD USDCAD USDCHF USDJPY)

for yr in ${yrs[*]};do
    for i in 0 1 2 3 4 5 6 7 8 9 10 11;do
        for pr in ${prs[*]};do
            url=$base/$yr/$yr-${mns[i]}/$pr-$yr-${mns[i]}.zip
            echo "Downloading $url"
	    wget $url
        done
    done
done

echo
echo "All Done"

