#!/usr/bin/env zsh

# Directory to search for .org files (current directory in this case)
SEARCH_DIR="."

# Number of parallel processes
NUM_PROCESSES=4

# Array to store background job PIDs
declare -a pids

# Counter for active jobs
active_jobs=0

# Find all .org files and process them
find "$SEARCH_DIR" -type f -name '*.org' | while read -r org_file; do
    # Generate the corresponding Markdown file path
    md_file="${org_file%.org}.md"

    # Convert the Org file to Markdown using Emacs in batch mode (in the background)
    (
        emacs --batch "$org_file" \
              -l ~/.emacs.d/init.el \
              --eval "(progn
                        (require 'org)
                        (find-file \"$org_file\")
                        (org-md-export-to-markdown)
                        (kill-buffer))"
        if [[ -f "$md_file" ]]; then
            print "Converted: $org_file -> $md_file"
        else
            print "Failed to convert: $org_file"
        fi
    ) &

    # Store the PID of the background job
    pids+=($!)

    # Increment the active job counter
    ((active_jobs++))

    # If we've reached the maximum number of parallel processes, wait for one to finish
    if ((active_jobs >= NUM_PROCESSES)); then
        wait -n
        ((active_jobs--))
    fi
done

# Wait for all remaining background jobs to finish
wait
