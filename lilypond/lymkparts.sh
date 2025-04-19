#!/usr/bin/env zsh

##########################################################################
# make parts                                                             #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2024-05-11 Sat>                                            #
# PURP: create parts from vscore.ly                                      #
#                                                                        #
# lymkparts.sh produces individual parts using information in vscore.ly  #
# by creating the scoreless tmpnoscore.ly file in the parts/             #
# directory. Then by running through each part (eg SpA, SpB ...) it      #
# checks if the part exists in tmpnoscore.ly and produces that part      #
# using the T2 template, runs it through lilypond, then adds the piano   #
# part, then runs that through lilypond. There are 2 scores produced for #
# each part this way. All tmp files are eventually deleted.              #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: produces individual parts for a song"
    echo "how: go to song directory and jri"
    exit
fi



#############
# Variables #
#############
CD=$(pwd)                       # current directory
VF=$CD/vscore.ly                # vscore.ly file
PD=$CD/parts                    # parts directory
NP=$CD/parts/TMPnoscore.ly      # noscore file in parts/
TP=$CD/parts/TMPparts.ly        # parts file in parts/
TS=$CD/parts/TMPsubs.ly         # tmp file for singer

zztmpls=~/ocs/agio/praductions/zztmpls
T2=$zztmpls/T2-singervars.ily    # singer and lyricvariables
T3=$zztmpls/T3-pianopartvars.ily # piano variables
T4=$zztmpls/T4-voicesscore.ily   # score voices
T5=$zztmpls/T5-pianoscore.ily    # score piano


# findparts cmd picks up soloists
# which an array of parts will not do
findparts=($(perl -ne 'print "$1 " if /%% (.*) %%/' $VF))



#############
# Functions #
#############
mkpartsdir() {
    if [[ ! -d parts ]]; then
        mkdir parts
    fi
}

mknoscore() {
    # variables $1 for <<, $2 for >>, etc could be used as arguments
    # however since this task is very specific that's just more work
    # remove midi line, then setup PART
    # BEGIN{} reads file as single line
    sed -i -e '/midi/d' $VF
    perl -pe "BEGIN{undef $/;} s/<<.*>>/\n<<\nTHEPARTS\n\n\nPIANO\n\n>>/sm" $VF > $NP
    TXT=$(printf '%q' "$(cat "$T5")")
    sed -i -e "s/PIANO/$TXT/" $NP
}

cleaner() {
    # cleans up the ' $'
    sed -i -e "s/\$'//g" $1
    sed -i -e "s/^'//g" $1
}


########
# Main #
########
echo $CD
mkpartsdir                      # ensure parts dir
mknoscore                       # create the TMPnoscore.ly file as template

for singer in $findparts; do
    echo $singer
    cp $NP $PD/$singer.ly
    OF=$PD/$singer.ly

    # create TMP file for singer with substitutions
    perl -e "s/SINGER/$singer/g;"\
         -e "s/SIN3/${singer[0,3]}/"\
         -p $T4 > $TS

    # substitute contents of TMP for THEPARTS in OF
    TXT=$(printf '%q' "$(cat "$TS")")
    # g switch is needed for some reason
    # also trying to do it with oneline -e doesn't work for last one
    sed -i -e "s/THEPARTS/$TXT/g" $OF
    cleaner $OF

    # lilypond it
    lilypond $OF
    
done

# cleanup
mv *pdf parts/
rm parts/TMP*



exit



#########
# Notes #
#########
TXT=$(printf '%q' "$(cat "$TS")")
is needed to get around the \n of \new etc which is a problem if we $(<$TS)

TODO sort out Mz, Al, Tn stuff and rewrite in all scores
TODO include piaperf section
TODO create absolute paths for zztmpls so we can test anywhere
