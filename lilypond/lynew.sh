#!/usr/bin/env zsh

##########################################################################
# lilypond new score                                                     #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - 2022-07-31                                                  #
# PURP: Creates new lilypond score.                                      #
#                                                                        #
# Makes the lilypond vscore.ly file given title and voices who are in   #
# order of vocal range high to low followed by the soloists who are kept #
# closest to the accompaniment. Details such as pitch and tempo are      #
# dealt with through substitutions as well.                              #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: makes vscore.ly skeleton for a praduction composition"
    echo "how: run from praductions/<PRADUCTION>/"
    echo "how: lypdnew.sh Title-Title voice1 voice2 ..."
    echo "voices should be in order soprano mezzo tenor baritone bass soloist(s)"
    echo "substitutions handled after vscore.ly is setup"
    exit
fi



#############
# Variables #
#############
OF=vscore.ly                    # output file

# templates
zztmpls=~/praductions/zztmpls   # praductions zztmpl directory
T1=$zztmpls/T1-begscore.ily     # beg template
T2=$zztmpls/T2-varvoice.ily     # voice and lyric variables
T3=$zztmpls/T3-varpiano.ily     # piano variables
T4=$zztmpls/T4-scovoice.ily     # score voices
T5=$zztmpls/T5-scopiano.ily     # score piano
T6=$zztmpls/T6-endscore.ily     # end template
TC2=$zztmpls/TC2-varchorus.ily  # chorus variables
TC4=$zztmpls/TC4-scochorus.ily  # chorus score

# set up from arguments
TITLE=$@[1]
VOICES=(${@:2})

# version number current
VN=`lilypond -v | head -n1 | cut -d' ' -f3`



########
# Main #
########
mkdir $TITLE
cd $TITLE

if [[ $VOICES[1] == "Chorus" ]]; then
    VOICES=( ${VOICES[@]:1} )
    cat $TC2 > T2tmp
    cat $TC4 > T4tmp
    # join chorus parts to other voices
    # chorus=( Spa Spb Mez Ten Bsa Bsb )
    # VOICES=($chorus ${VOICES[@]:1})
fi

# start with version,language,headers
echo "\\\version \"$VN\"" > $OF
cat $T1 >> $OF 

# chorus voice setup
if [[ -e T2tmp ]]; then
    cat "T2tmp" >> $OF
    rm "T2tmp"
fi
   
for voice in $VOICES; do
    #add setup of voices
    perl -e "s/VOICE/$voice/"\
         -p $T2 >> $OF

    perl -e "s/VOICE/$voice/g;"\
         -e "s/VOI3/${voice[0,3]}/"\
         -p $T4 >> TMP
done

# add piano part variables
cat $T3 >> $OF

# start the score section
echo "% * score
\score {
  <<\n" >> $OF

# chorus score setup
if [[ -e T4tmp ]]; then
    cat "T4tmp" >> $OF
    rm "T4tmp"
fi

# add voicelyric to score
cat TMP >> $OF
rm TMP

# add piano to score
cat $T5 >> $OF

# add end
cat $T6 >> $OF

# set title
perl -e "s/TITLE/$TITLE/"\
     -pi $OF


# make substitutions in header and global for vscore.ly

echo "subtitle|key(c..)|mode(major..)|num(4)|den(4)|desc(Adagio)|meter(4=88)"
read x
arr=(${(@s:|:)x})

# substitutions in scores
perl -e "s/SUB/$arr[1]/;"\
     -e "s/KEY/$arr[2]/;"\
     -e "\s/MODE/$arr[3]/;"\
     -e "\s/NUM/$arr[4]/;"\
     -e "\s/DEN/$arr[5]/;"\
     -e "\s/DESC/$arr[6]/;"\
     -e "\s/METER/$arr[7]/"\
     -pi vscore.ly



exit



#########
# Notes #
#########


# vocal score is the primary document other scores are formed from
# so we set this up first and do the rest (vscore.pdf|midi ...) later

# annotation and testing !!!
