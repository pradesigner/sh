#!/usr/bin/zsh

# Create a secure temporary file for storing passwords
TMPFILE=passwords.csv
echo "url,username,password" > $TMPFILE

# Iterate over all password entries in ~/.password-store
for entry in $(find ~/.password-store -name "*.gpg"); do
    itm=${${entry#*store/}%.*}       # Extract entry name without path or extension
    url=https://${itm%/*}            # Extract URL/domain (before "/")
    usr=${itm#*/}                    # Extract username (after "/")
    
    # Skip entries without valid URL or username structure
    [[ -n "$url" && -n "$usr" ]] || continue
    
    # Decrypt password using pass
    psw=$(pass show $itm)
    
    # Escape fields and append to CSV file
    echo "\"$url\",\"$usr\",\"$psw\"" >> $TMPFILE
    
    # Optional: Display progress for debugging purposes
    echo "Processed: $itm"
done

# Output final location of CSV file (for importing into Firefox)
echo "Passwords exported to: $TMPFILE"

# Reminder: Delete temporary file after importing!
