#!/usr/bin/env zsh

# created by pp for the org-to-md conversion (not used though)

# Define the base directory (update this if needed)
BASE_DIR="content"

# Find all *index.org files recursively in the content directory
find "$BASE_DIR" -type f -name "*index.org" | while read -r org_file; do
  # Get the directory and filename without extension
  dir=$(dirname "$org_file")
  base=$(basename "$org_file" .org)

  # Define the new Markdown file path
  md_file="$dir/$base.md"

  # Convert the .org file to .md using your org-to-md script
  echo "Converting $org_file to $md_file..."
  org-to-md.zsh "$org_file" > "$md_file"

  # Rename the original .org file to .TMP
  tmp_file="$dir/$base.TMP"
  echo "Renaming $org_file to $tmp_file..."
  mv "$org_file" "$tmp_file"
done

echo "Conversion complete!"
