#!/usr/bin/env zsh

if [[ $1 == '-h' ]]; then
    echo "use: Run OCR on a multi-page PDF file and create a txt with the"
    echo "     extracted text in hidden layer. Requires tesseract, gs."
    echo "how: pdf2ocr.sh input.pdf output.txt"
    exit
fi

#TODO originally a bash script so it may not work
# there are probably better ways to ocr

set -e

input="$1"
output="$2"

#tmpdir="$(mktemp -d)"
tmpdir=tmp

# extract images of the pages (note: resolution hard-coded)
gs -SDEVICE=tiff24nc -r300x300 -sOutputFile="$tmpdir/page-%04d.tiff" -dNOPAUSE -dBATCH -- "$input"

# OCR each page individually and convert into PDF
for page in "$tmpdir"/page-*.tiff
do
    base="${page%.tiff}"
    tesseract "$base.tiff" $base
done

# combine the pages into one txt
cat "$tmpdir"/page-*.txt > $output

#rm -rf -- "$tmpdir"
