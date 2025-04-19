#!/usr/bin/env bash

# rsyncs the indicators and templates for all mts
# usage: jri

# the 's' option is to prevent remote shell from interpreting and solves spaces

cd

MACH=(ovon ranjana@ovon psinom)
BASE=".wine/drive_c/Program Files"

DMTmql="$BASE/dmt4/MQL4/"
RMTmql="$BASE/rmt4/MQL4/"
DMTtem="$BASE/dmt4/templates/"
RMTtem="$BASE/rmt4/templates/"
DMTpro="$BASE/dmt4/profiles/"
RMTpro="$BASE/rmt4/profiles/"

rsync -av forex/ ovon:
rsync -av forex/ psinom:

rsync -a --delete "$DMTmql" "$RMTmql"
rsync -a --delete "$DMTtem" "$RMTtem"
rsync -a --delete "$DMTpro" "$RMTpro"

for mach in ${MACH[@]}; do
    echo $mach
    rsync -as --delete "$DMTmql" $mach:"$DMTmql"
    rsync -as --delete "$DMTmql" $mach:"$RMTmql"
    rsync -as --delete "$DMTtem" $mach:"$DMTtem"
    rsync -as --delete "$DMTtem" $mach:"$RMTtem"
    rsync -as --delete "$DMTpro" $mach:"$DMTpro"
    rsync -as --delete "$DMTpro" $mach:"$RMTpro"
done
