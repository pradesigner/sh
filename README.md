# zsh scripts
This is a collection of zsh scripts here accessible through ~sh and symlinked into ~/bin when appropriate.

## Description
We have created zsh scripts for many years now. We plan to have a zsh resource illustrating various
techniques at some point.

## Installation
NA.

## Usage
Scripts have a -h flag which shows  
use:  
how:

## Technical Details
We use the following template for all zsh scripts of any significance.

```
#!/usr/bin/env zsh

title

AUTH: pradesigner
VDAT: v1 - 
PURP: 

desc


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: "
    echo "how: "
    exit
fi



#############
# Variables #
#############



#############
# Functions #
#############



########
# Main #
########



exit



#########
# Notes #
#########

```

Use -h to find out what each does or do a bat on the script to get more
detail.

Most of the scripts are linked to ~/bin/ for use.

Specialized scripts are collected in an appropriate dir.

Inactive scripts which includes other languages are found in zz/ to keep
them out of the way.

There is a zzotes.org link to zsh notes that are on tf.

There is a zztmpls link to ocs/esign/prg/zztmpls/ which contains a
zshtmpl.sh providing a blank annotated template to start scripts with.

There will be more work done on this README as we progress.

## License
Program is copyleft. All items are created by pradesigner often with help from perplexity AI, unless otherwise credited.
