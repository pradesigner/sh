#/usr/bin/env zsh

# created by pp for the org-to-md conversion
# more attempts to solve the org-hugo-base-dir problem
# which didn't go well partly because there is no
# org-hugo-base-directory
# but also because the entire effort just didn't work
# resulting in our dropping ox-hugo

# emacs --batch -l ~/.emacs.d/init.el \
#   --eval "(progn
#             (setq default-directory \"$(pwd)/\")
#             (find-file \"content/YOUR_TEST_FILE.org\")
#             (message \"Dir-locals: %S\" (dir-locals-get-class-variables 'org-mode))
#             (message \"Base dir: %s\" org-hugo-base-directory))"

emacs --batch -l ~/.emacs.d/init.el \
  --eval "(progn
            (setq default-directory \"$(pwd)/\")
            (load-file \".dir-locals.el\")
            (message \"HUGO_BASE_DIR: %s\" org-hugo-base-directory))"
