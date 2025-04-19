#!/usr/bin/env zsh

#######################################################################
# reject email addresses                                              #
#                                                                     #
# AUTH: pradesigner                                                   #
# VDAT: v1 - <2020-08-01 Sat>                                         #
# PURP: Add to email rejects                                          #
#                                                                     #
# rejects.sh added spammer email addresses to the /etc/postfix/access #
# file identifying any duplications. That file is then converted by   #
# postmap into access.db for the postfix program. This is a simple,   #
# manual mechanism for blocking spammers and tends to work reasonably #
# well without setting up spamassassin or other baysian systems.      #
#######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: adds REJECT emails to access and creates access.db on lentil"
    echo "how: rejects.sh email1 email2 ..."
    exit
fi



########
# Main #
########
ssh lentil sudo cp /etc/postfix/access /etc/postfix/access.BKP
for e in $@; do
    echo "$e REJECT" | ssh lentil sudo tee -a /etc/postfix/access
done

ssh lentil 'cat /etc/postfix/access ; sudo postmap /etc/postfix/access'



exit



#########
# Notes #
#########


# see if duplicates can be caught then rejected automatically !!!

# previous way which wasn't nearly as concise
# and stopped working for some reason

# #touch /tmp/REJECTS
# for e in $@; do
#     echo "$e REJECT" >> /tmp/REJECTS
# done

# scp /tmp/REJECTS lentil:/tmp/

# ssh lentil <<'EOF'
# sudo -i 
# cd /etc/postfix
# sudo cp access access.BKP
# sudo cat /tmp/REJECTS >> access
# sudo cat access
# sudo postmap access
# sudo postfix reload
# sudo rm /tmp/REJECTS
# EOF

# rm /tmp/REJECTS
