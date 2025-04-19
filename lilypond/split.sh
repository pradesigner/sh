#!/usr/bin/env zsh

#########################################################################
# This is a split version of the praduction score which we decided not  #
# to pursue after trying it out. The idea was a good one, but did not   #
# facilitate development. The original intent was to bypass frescobaldi #
# crashes when folding. Once we switched to emacs and outshine, there   #
# was no need to use split system.                                      #
#########################################################################

# makes ly score skeleton for praductions
# usage: lpnew.sh Title-Title singer1 singer2 ...
# singers should be in order soprano mezzo tenor baritone bass soloist(s)
# run from praductions/<PRADUCTION>/

zztmpls=~/ocs/agio/praductions/zztmpls
Tvlheader=$zztmpls/vlheader.ily
Tnewscore1=$zztmpls/newscore1.ily
Tnewscore2=$zztmpls/newscore2.ily
Tsinger=$zztmpls/singer.ily
Tsingerlist=$zztmpls/singerlist.ily
TpianoU=$zztmpls/pianoU.ily
TpianoL=$zztmpls/pianoL.ily

TITLE=$@[1]
SINGERS=(${@:2})

mkdir $TITLE
cd $TITLE

cp $Tvlheader score.ly
cat $Tnewscore1 >> score.ly

# singer setup 
for singer in $SINGERS; do
    # singer note and text files
    cp $Tvlheader $singer.ly
    cat $Tsinger >> $singer.ly
    touch $singer.tx

    # score-singer.ly files
    cp $Tvlheader score-$singer.ly
    cat $Tnewscore1 >> score-$singer.ly
    
    # singers to score.ly
    sed -e "s/SINGER/$singer/g"\
        -e "s/SIN3/${singer[0,3]}/"\
        $Tsingerlist > TMP

    # singer to score-singer.ly and close
    cat TMP >> score-$singer.ly
    cat $Tnewscore2 >> score-$singer.ly

    # singer to score.ly
    cat TMP >> score.ly
    
done

rm TMP

# close score.ly
cat $Tnewscore2 >> score.ly

# score-piano
cp $Tvlheader score-piano.ly
cat $Tnewscore1 >> score-piano.ly
cat $Tnewscore2 >> score-piano.ly

# piano files
cp $TpianoU pianoU.ly
cp $TpianoL pianoL.ly

# set title
sed -i "s:TITLE:$TITLE:" score*.ly


exit

