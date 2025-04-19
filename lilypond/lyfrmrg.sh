#!/usr/bin/env zsh

########################################################################
# lilypond from rosegarden                                             #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2022-07-31 Sun>                                          #
# PURP: Make lilypond score from rosegarden notation.                  #
#                                                                      #
# lyfrmrg.sh takes the output from a rosegarden score lilypond         #
# conversion, updates it and puts it into a format that is praductions #
# suitable. The final product is an improvement, though requires       #
# considerable massaging to be consistent with the usual standard.     #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: converts rg to improved ly"
    echo "how: rgly.sh <file> (in file's dir)"
    exit
fi



########
# Main #
########

# done with sed, then perl

# double backslash since perl removes them
PF=$(sed 's/\\/\\\\/' /home/pradmin/ocs/agio/praductions/zztmpls/paper.ily)

# updates rg's ly to latest version
convert-ly -e $1

# sets the emptystaves context pro#perly
# sed -i 's/RemoveEmptyStaves/RemoveAllEmptyStaves/' $1
perl -pi -e 's/RemoveEmptyStaves/RemoveAllEmptyStaves/' $1

# sets the paper parameters (notice where the delete is placed)
# sed -i \
#     -e '/#(set-default-paper-size .*)/{r /home/pradmin/ocs/agio/praductions/zztmpls/paper.ily' \
#     -e 'd}' $1
perl -pi -e "s/#\(set-default-paper-size \"a4\"\)/$PF/" $1

# open the pianostaff
# sed -i 's/\(.*Staff.*pianoU. <<\)/\\new PianoStaff \\with { instrumentName = "Piano" }\n<<\n\1/' $1
perl -pi -e 's/(.*Staff.*pianoU. <<)/\\new PianoStaff \\with { instrumentName = "Piano" }\n<<\n\1/' $1


# close the pianostaff brace 
# sed -i 's/\(Staff (final) ends\)/\1\n      >>/' $1
perl -pi -e 's/(Staff \(final\) ends)/\1\n      >>/' $1

# remove the pianoU pianoL lines
# sed -i \
#     -e '/pianoL /d' $1 \
#     -e '/pianoU /d' $1
perl -i -n -e 'print unless m/piano[UL] /' $1

rm $1~
lilypond $1

echo "All done!"



exit



#########
# Notes #
#########


# Made at a time when we were experimenting with sed and perl. We should convert exclusively to perl !!!
