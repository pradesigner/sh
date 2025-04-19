#!/usr/bin/env bash

# starts up a mtX
# usage: mtx [A|B|C|D]

cd pfwine/mt$1
wine terminal.exe&
#wine metaeditor.exe&
