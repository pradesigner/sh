#!/usr/bin/env zsh

# creates ~/.local/share/rosegarden/library/yoshimi.rgd from /usr/share/yoshimi/banks
# usage: jri (must use zsh or parameter substitution will not work)

YDIR=/usr/share/yoshimi/banks
yoshimirgd=~/.local/share/rosegarden/library/yoshimi.rgd

# first part of a yoshimi.rgd file
T1='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rosegarden-data><rosegarden-data version="4-0.9.1">
    <studio recordfilter="0" thrufilter="0">
    <device direction="play" id="0" name="Yoshimi" type="midi" variation="LSB">
        <librarian email="lorenzofsutton@gmail.com" name="Lorenzo Sutton" />
        <controls>
            <control colourindex="2" controllervalue="10" default="64" description="&lt;none&gt;" ipbposition="0" max="127" min="0" name="Pan" type="controller" />
            <control colourindex="3" controllervalue="93" default="0" description="&lt;none&gt;" ipbposition="1" max="127" min="0" name="Chorus" type="controller" />
            <control colourindex="1" controllervalue="7" default="100" description="&lt;none&gt;" ipbposition="2" max="127" min="0" name="Volume" type="controller" />
            <control colourindex="3" controllervalue="91" default="0" description="&lt;none&gt;" ipbposition="3" max="127" min="0" name="Reverb" type="controller" />
            <control colourindex="4" controllervalue="64" default="0" description="&lt;none&gt;" ipbposition="-1" max="127" min="0" name="Sustain" type="controller" />
            <control colourindex="2" controllervalue="11" default="127" description="&lt;none&gt;" ipbposition="-1" max="127" min="0" name="Expression" type="controller" />
            <control colourindex="4" controllervalue="1" default="0" description="&lt;none&gt;" ipbposition="-1" max="127" min="0" name="Modulation" type="controller" />
            <control colourindex="2" controllervalue="74" default="64" description="&lt;none&gt;" ipbposition="2" max="127" min="0" name="Cutoff Freq" type="controller" />
            <control colourindex="2" controllervalue="71" default="64" description="&lt;none&gt;" ipbposition="2" max="127" min="0" name="Resonance" type="controller" />
            <control colourindex="2" controllervalue="73" default="64" description="&lt;none&gt;" ipbposition="2" max="127" min="0" name="Attack time" type="controller" />
            <control colourindex="2" controllervalue="72" default="64" description="&lt;none&gt;" ipbposition="2" max="127" min="0" name="Release time" type="controller" />
            <control colourindex="4" controllervalue="1" default="8192" description="&lt;none&gt;" ipbposition="-1" max="16383" min="0" name="PitchBend" type="pitchbend" />
        </controls>'

# second part of a yoshimi.rgd file
T2='</device>
</studio>
</rosegarden-data>'


# put part1 on
echo $T1 > $yoshimirgd

# go to /usr/share/yoshimi/banks for further operations
cd $YDIR

# templates to substitute into
Btempl='<bank lsb="0" msb="NUM" name="BANK" percussion="false">'
Itempl='<program category="BANK" id="IDEN" name="NAME" />'


# put the banks and instruments in to the yoshimi.rgd file
N=0
for BA in $(ls -1 | LC_COLLATE=C sort); do
    ((N+=5))
    Btxt=${${Btempl:s/NUM/$N/}:s/BANK/$BA}
    echo $Btxt >> $yoshimirgd
    for IN in $BA/*; do
        #ID=${${IN%%-*}#*/}
        ID=$(echo ${${IN%%-*}#*/} | bc) #str->int
        ((ID-=1)) #dec ID so instruments match up on import
        NAM=${${IN#*-}%.*}
        Itxt=${${${Itempl:s/IDEN/$ID}:s/NAME/$NAM}:s/BANK/$BA}
        echo $Itxt >> $yoshimirgd
    done
    echo "</bank>" >> $yoshimirgd
done

# put the part2 into the yoshimi.rgd
echo $T2 >> $yoshimirgd

echo "all done"

exit
