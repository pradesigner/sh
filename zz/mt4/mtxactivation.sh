#!/usr/bin/env bash

# starts up a mt on psinom or acari
# usage: mtxactivation [A|B|C|D]

ssh -X psinom ~/bin/mtx $1 &
