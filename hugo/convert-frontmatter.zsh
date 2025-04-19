#!/usr/bin/env zsh

# created by pp for the org-to-md conversion (not used since we dropped ox-hugo)

# Safely convert front matter to ox-hugo properties
find content -name '*index.org' | while read -r file; do
  # First check if file has front matter
  if grep -q '^---' "$file"; then
    sed -i '
      1,/^---$/ {
        /^---$/d;
        s/^title: /#+title: /;
        s/^date: /#+date: /;
        s/^author: /#+author: /;
        s/^description: /#+description: /;
        s/^categories: /#+hugo_categories: /;
        s/^tags: /#+hugo_tags: /;
      }
    ' "$file"
    echo "Converted: $file"
  else
    echo "Skipped (no front matter): $file"
  fi
done


find content -name '*index.org' | while read -r file; do
  sed -i '
    1,/^---$/! { q; };  # Skip files without front matter
    1,/^---$/ {
      /^---$/d;
      s/^title: /#+title: /;
      s/^date: /#+date: /;
      s/^author: /#+author: /;
      s/^description: /#+description: /;
      s/^categories: /#+hugo_categories: /;
      s/^tags: /#+hugo_tags: /;
      /^---$/d;
    }
    ' "$file"
  echo "Converted: $file"
done
