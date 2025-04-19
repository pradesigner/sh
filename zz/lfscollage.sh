#!/bin/bash
# collage pic preparer for lfs

shopt -s nocaseglob

# removes spaces and changes extension to .jpg
for e in *.jpg; do
    e1=${e// /}
    e2=${e1%.*}`date -u +%y%m%d`.jpg
    mv $e $e2
done

# scales to 450
mogrify -scale 450 *.jpg

# copies to server
scp *.jpg plexus:lfs/images/collage/

# moves locally 
mv *.jpg ~/www/lfs/ber/images/collage/

shopt -u nocaseglob

echo All Done!
