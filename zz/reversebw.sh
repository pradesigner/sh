#!/usr/bin/env bash

# reverses black and white using imagemagick negate and mask
# usage: ./bwreverse.sh image.png

IMG=$1

convert $IMG -colorspace HSB -channel g -separate +channel -threshold 0% mask

convert $IMG \( -clone 0 -negate \) \( -clone 0 -colorspace HSB -channel g -separate +channel -threshold 0% -negate \) -compose over -composite $IMG

convert $IMG -white-threshold 90% -fill white $IMG

rm mask
