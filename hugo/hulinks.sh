#!/usr/bin/env zsh

##########################################################################
# hulinks                                                                #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2025-04-10 Thu>                                            #
# PURP: checks links in hugosite/content                                 #
#                                                                        #
# hulinks.sh looks at absolute and relative links in all *index.md files #
# testing the former with curl and the latter by [[ -e ]]. If the check  #
# fails, the link is reported. Assisted by PP.                           #
##########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: checks for broken links in hugo content/"
    echo "how: hulinks.sh <hugodir>"
    exit
fi



#############
# Variables #
#############
CONTENT_DIR="$HOME/tf/content"  # Adjust to your Hugo project root
HUGO_BASE_URL="http://localhost:1313"     # Local Hugo server URL
VALID_STATUS_CODES=(200 301 302 303)


#############
# Functions #
#############



########
# Main #
########

fd -g '*index.md' "$CONTENT_DIR" | while read -r mdfile; do 
    echo "Checking $mdfile"

    # # check http[s]
    # grep -Po '(?<=href=")https?://[^"]*' "$mdfile" | while read -r httplink; do
    #     statuscode=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "$httplink")

    #     if [[ $VALID_STATUS_CODES[$statuscode] ]]; then
    #         echo "  ❌ Broken HTTP link: $httplink (Status: $statuscode)"
    #     else
    #         echo "  ✅ Valid HTTP link: $httplink"
    #     fi
    # done
    # echo

    # check relref
    grep -Po '(?<={{< relref ")[^"]*' "$mdfile" | while read -r relref_path; do
        # Handle paths with/without .md extension
        target_file="${relref_path%.md}"
        full_path="$CONTENT_DIR/$target_file"

        if [[ ! -e "$full_path" ]]; then
            echo "  ❌ Broken relref: '$relref_path' (File not found: $full_path)"
        else
            echo "  ✅ Valid relref: '$relref_path'"
        fi
    done
done



exit



#########
# Notes #
#########

#!/bin/zsh

# Define directories
CONTENT_DIR="$HOME/path/to/hugo/content"  # Adjust to your Hugo project root
HUGO_BASE_URL="http://localhost:1313"     # Local Hugo server URL

# Find all index.md files in content/
fd -g 'index.md' "$CONTENT_DIR" | while read -r md_file; do
  echo "Checking links in: $md_file"

  # ------------------------------------
  # 1. Check HTTP/HTTPS Links
  # ------------------------------------
  grep -Po '(?<=href=")https?://[^"]*' "$md_file" | while read -r http_link; do
    status_code=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "$http_link")

    if [[ "$status_code" -ne 200 ]]; then
      echo "  ❌ Broken HTTP link: $http_link (Status: $status_code)"
    else
      echo "  ✅ Valid HTTP link: $http_link"
    fi
  done

  # ------------------------------------
  # 2. Check relref Shortcodes
  # ------------------------------------
  grep -Po '(?<={{< relref ")[^"]*' "$md_file" | while read -r relref_path; do
    # Handle paths with/without .md extension
    target_file="${relref_path%.md}.md"
    full_path="$CONTENT_DIR/$target_file"

    if [[ ! -e "$full_path" ]]; then
      echo "  ❌ Broken relref: '$relref_path' (File not found: $full_path)"
    else
      echo "  ✅ Valid relref: '$relref_path'"
    fi
  done
done

echo "Link validation complete."


exit
