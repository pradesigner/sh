#!/usr/bin/env zsh

# created by pp for the org-to-md conversion (not used because we dropped ox-hugo)
# there were too many issues with setting org-hugo-base-dir

# Export all *index.org to *index.md using emacs batch mode

find content -name '*.org' | while read -r orgfile; do
  md_file="${orgfile%.org}.md"
  
  emacs --batch \
    -l ~/.emacs.d/init.el \
    --eval "(progn 
              (setq default-directory \"$(pwd)/\")
              (setq org-hugo-base-dir \"./\")
              (find-file \"$orgfile\") 
              (message \"Base dir: %s\" org-hugo-base-dir)
              (org-hugo-export-wim-to-md t))"
  
  [[ -f "$md_file" ]] || { echo "❌ Export failed: $orgfile"; exit 1 }
  echo "✅ $orgfile → $md_file"
done
