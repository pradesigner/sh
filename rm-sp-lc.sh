#!/usr/bin/env zsh

##########################################################################
# filename spaceless-lowercase                                           #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2023-08-01 Tue>                                            #
# PURP: Remove spaces and lowercase                                      #
#                                                                        #
# rm-sp-lc.sh replaces spaces with hypens and lowercases all letters     #
# from filenames making them more convenient to work with. We tend to    #
# standardize all filenames along these lines whenever it is sensible to #
# do so.                                                                 #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: for a file remove spaces and make lower case"
    echo "how: rmsplc.sh *.ext"
    exit
fi



########
# Main #
########
for e in "$@"; do # $@ must be in quotes to handle spaces in filenames
    f=$(echo $e | tr -d " " | tr "A-Z" "a-z")
    mv "$e" "$f"
done



exit



#########
# Notes #
#########


# there are likely better ways of doing this renaming now that we have zmv working !!!
# such as this one that gemini produced

#!/bin/zsh

# This script renames files in the current directory and its subdirectories.
# It performs the following transformations:
# 1. Converts filenames to lowercase.
# 2. Replaces spaces with hyphens.
# 3. Removes all non-alphanumeric characters, *except* hyphens and the extension dot.
#
# Usage: ./rename_files.zsh <extension1> [extension2] ...
# Example: ./rename_files.zsh md txt jpg

# Load the zmv utility if not already loaded in your .zshrc
autoload -U zmv

# --- Input Validation ---
# Check if any arguments (file extensions) are provided
if (( $# == 0 )); then
  echo "Error: No file extensions provided."
  echo "Usage: $0 <extension1> [extension2] ..."
  echo "Example: $0 md txt jpg"
  exit 1
fi

# --- Pattern Construction ---
# Create an array of patterns for each provided extension
# For example, if arguments are "md", "txt", this will become ("*.md", "*.txt")
local patterns=()
for ext in "$@"; do
  # Ensure the extension doesn't start with a dot, add it if missing
  local clean_ext="${ext##.}" # Removes leading dot if present
  patterns+=("*.$clean_ext")
done

# Join the individual patterns with '|' to create a single OR-pattern for zmv
# Example: "(*.md|*.txt)"
local combined_extension_pattern="(${patterns:j:|})"

# --- ZMV Renaming Command ---
# The zmv command will preview the changes before execution.
# It's highly recommended to run with '-n' (dry-run) first!
# Remove the '-n' flag to execute the actual renaming.

# Explanation of the zmv command:
# zmv -n: Dry-run mode (shows changes without applying them). Remove '-n' to apply.
# '(**/)('$combined_extension_pattern')': This is the source pattern.
#   - '(**/)': Matches any directory path (including none) and captures it as $1.
#              This makes the renaming recursive and preserves directory structure.
#   - '(': Starts a capturing group for the filename.
#   - $combined_extension_pattern: Inserts the dynamically generated pattern for extensions
#                                  (e.g., "*.md|*.txt").
#   - ')': Closes the capturing group for the filename.
#
# '$1${${${REPLY:l}// /-}//[^[:alnum:]\.-]/}': This is the replacement pattern.
#   - '$1': Inserts the captured directory path from the source pattern.
#   - '${REPLY:l}': Converts the entire matched filename (including its extension) to lowercase.
#                   `REPLY` refers to the full string matched by the second capturing group.
#   - '${...// /-}': Replaces all spaces (` `) in the result of the previous step with hyphens (`-`).
#   - '${...//[^[:alnum:]\.-]/}': Removes any character that is *not* one of the following:
#       - `[:alnum:]`: An alphanumeric character (letters a-z, A-Z, and numbers 0-9).
#       - `\-`: A hyphen.
#       - `\.`: A literal dot (escaped to prevent it from being a regex wildcard).
#     This ensures that hyphens and the extension dot are preserved, while other special
#     characters (like underscores, commas, parentheses, etc.) are removed.

echo "Performing a dry run of file renaming for extensions: $@"
echo "-------------------------------------------------------"
zmv -n '(**/)('$combined_extension_pattern')' '$1${${${REPLY:l}// /-}//[^[:alnum:]\.-]/}'
echo "-------------------------------------------------------"
echo "Dry run complete. No files have been changed."
echo "To apply these changes, remove the '-n' flag from the 'zmv' command in the script."
echo "Example: zmv '(**/)('$combined_extension_pattern')' '$1\${...}'"





