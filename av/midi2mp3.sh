#!/usr/bin/env zsh

########################################################################
# midi to mp3                                                          #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2023-08-01 Tue>                                          #
# PURP: Converts a midi file to mp3.                                   #
#                                                                      #
# midi2mp3.sh uses fluidsynth or timidity to convert an midi into mp3. #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: converts midi to mp3 using fluidsynth"
    echo "how: midi2mp3.sh <midi file>"
    exit
fi



########
# Main #
########
# fluidsynth -l -T raw -F - /usr/share/soundfonts/FluidR3_GM.sf2 $1 | twolame -b 256 -r - ${1%.*}.mp3

# timidity input.mid -Ow -o output.wav

# timidity output.mid -Ow -o - | ffmpeg -i - -acodec libmp3lame -ab 64k  output.mp3




exit



#########
# Notes #
#########


# work on this possible offering a choice or not !!!
