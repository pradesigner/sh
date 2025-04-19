#!/usr/bin/env zsh

################################################################
# Clear swap and cache                                         #
#                                                              #
# AUTH: pradesigner                                            #
# VDAT: v1 - <2023-07-31 Mon>                                  #
# PURP: Clears the swap and the cache.                         #
#                                                              #
# Clears out both the swap area and the cache stored in /proc. #
################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: clears swap and cache"
    echo "how: jri"
    exit
fi



########
# Main #
########
sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches" # clear cache

# reset the swap
sudo swapoff -a
sudo swapon -a

echo "all done"



exit



#########
# Notes #
#########

