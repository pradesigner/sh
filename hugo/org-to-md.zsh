#!/usr/bin/env zsh

# created by pp for the org-to-md conversion
# used with fd and pandoc to turn *index.org to *index.md

org_file="$1"
md_file="${org_file%.org}.md"

# Extract and write frontmatter
perl -n0777 -e 'print $1 if /(^---\s*\n.*?\n---\s*\n)/s' "$org_file" > "$md_file"

# Convert and append content
perl -n0777 -e 's/^---\s*\n.*?\n---\s*\n//s; print' "$org_file" | \
pandoc -f org -t gfm >> "$md_file"

echo "$org_file done"

exit
