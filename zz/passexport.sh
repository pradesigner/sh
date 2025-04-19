#!/usr/bin/env bash
# export pass passwords to external file
# if you are running gpg-agent (and your passphrase is loaded)
# https://unix.stackexchange.com/questions/170519/export-passwords-from-the-pass-password-manager


shopt -s nullglob globstar
prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

for file in "$prefix"/**/*.gpg; do                           
    file="${file/$prefix//}"
    printf "%s\n" "Name: ${file%.*}" >> exported_passes
    pass "${file%.*}" >> exported_passes
    printf "\n\n" >> exported_passes
done
