#!/usr/bin/env zsh

# joins name{1..x}.mp4 into name.mp4 
# usage: join-mp4.sh S|C <name> where S simple, C coded

if [[ -z $1 ]]; then
    echo "usage: join-mp4.sh <basename>"
    exit    
fi

BN=$1 #basename for filenames base1,base2,...
TP=list.txt #temporary list of files at /tmp/list.txt
OF='out' #outfile name

# create fileslist
find $BN*.mp4 | sed 's/^/file /' > $TP

# simplest joining (concat demuxer)
ffmpeg -f concat -safe 0 -i $TP -c copy out.mp4

# remove list.txt
rm list.txt

exit


## attempts to use ffmpeg more effectively
# case $SC in
#     S) # simplest way to join mp4 files that don't need recoding
#         ffmpeg -f concat -i $TP -codec copy $2.mp4
#         echo "simple join done into file $FB.mp4"
#         ;;
#     C)
#         zmodload zsh/mapfile
#         i=0
#         for l in "${(f)mapfile[$TP]}"; do
#             f=${l#* }
#             echo $f
#             ffmpeg -i $f -c copy -bsf:v h264_mp4toannexb -f mpegts TS$f.ts
#         done
#         tsphrase=$(ls -xm -w 0 *.ts | sed 's/, /|/g')
#         ffmpeg -i "concat:$tsphrase" -c copy -bsf:a aac_adtstoasc aanew.mp4
        
#         ;;
#     *)
#         echo "use S|C where S simple, C coded - then the filesbase!"
#         ;;
# esac


# or without intermediate files via piping
# ls Movie_Part_1.mp4 Movie_Part_2.mp4 | \
# perl -ne 'print "file $_"' | \
# ffmpeg -f concat -i - -c copy Movie_Joined.mp4

# ffmpeg -i out01.mp4 -i out02.mp4 -i out03.mp4 -r 30 -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a] concat=n=3:v=1:a=1 [ov] [oa]" -map "[ov]" -map "[oa]" z.mp4
