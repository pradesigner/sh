#!/usr/bin/env zsh

##########################################################################
# video splicer                                                          #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Splices segments from multiple videos.                           #
#                                                                        #
# vidsplice.sh splices video from segments from various files using      #
# details setup in the splices text file which should be in the same     #
# directory as the video files. The format of the splices file is        #
#                                                                        #
# f1 00:00:00 00:50:08                                                   #
# f2 00:00:00 00:12:47                                                   #
# f1 00:50:10 00:58:52                                                   #
#                                                                        #
# The system works quite well especially if there are many files to work #
# with, though it can likely be improved upon considerably.              #
##########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: splices video from segments from various files"
    echo "how: vidsplice.sh f1.mp4 f2.mp4 ... after setting up splices file"
    exit
fi



#############
# Variables #
#############
# file assignments upto 6
f1=$@[1]
f2=$@[2]
f3=$@[3]
f4=$@[4]
f5=$@[5]
f6=$@[6]

# get the splices array
zmodload zsh/mapfile
lines=("${(f@)mapfile[splices]}")



########
# Main #
########
# create the splices and form ts files from them
i=0
for l in $lines; do
    ((i++))
    larr=( ${=l} )
    eval inp="\$$larr[1]"
    sta=$larr[2]
    end=$larr[3]
    out="out${(l(2)(0))i}.mp4"

    # create the out files as mp4
    ffmpeg -i $inp -ss $sta -to $end -c:v libx264 $out
    #ffmpeg -i $inp -ss $sta -to $end -c copy $out #not coding in h264 but often works

    # turn the out files into ts
    #ffmpeg -i $out -c copy -bsf:v h264_mp4toannexb -f mpegts TS$out.ts

done

## setup ts files - but this only gives audio, so not sure what it's purpose was
#tsphrase=$(ls -xm -w 0 *.ts | sed 's/, /|/g')
#ffmpeg -i "concat:$tsphrase" -c copy -bsf:a aac_adtstoasc aanew.mp4
#rm out*

vidjoins.sh out # join up all part files to out.mp4
rm out??.mp4 # remove all part files

echo "spliced file is out.mp4"



exit



#########
# Notes #
#########


# could be considerably improved though the idea is a good one !!!

# i=0
# while IFS=' ' read -A args; do
#     ((i++))
#     eval inp="\$${args[1]}"
#     sta="${args[2]}"
#     end="${args[3]}"
#     out="out${(l(2)(0))i}.mp4"
#     cmd+=("ffmpeg -i $inp -ss $sta -to $end -c copy $out")
# done < splices

## so why didn't the above idea work for linagi?
## and we had to make and array system with it?

# for c in $cmd; do
#     eval $c
# done





