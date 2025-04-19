#!/usr/bin/env zsh

##########################################################################
# restart emacs instance                                                 #
#                                                                        #
# AUTH: pradesigner                                                      #
# VDAT: v1 - <2024-10-11 Fri>                                            #
# PURP: restarts emacs with last file in buffer                          #
#                                                                        #
# restart-emacs-inst.sh tracks the file in the emacs buffer and restarts #
# emacs with the same file thus updating any mode changes. it is handed  #
# the file by an elisp program which is launched from emacs. the system  #
# is very useful for making mode changes and seeing the results right    #
# away since things like reloading init, or revert buffer just does not  #
# work because emacs-mode-file does not work the same as                 #
# browser-stylesheet-webpage. Created with PP assistance.                #
##########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: triggered by elisp function restart-emacs-instance"
    echo "how: dnr"
    exit
fi



#############
# Variables #
#############
EMACS_PID=$(ps -o ppid= -p $$ | tr -d ' ') # gets PID to kill current instance
CURRENT_FILE=$(cat /tmp/emacs_current_file.txt) # filename courtesy of restart-emacs-instance



########
# Main #
########
# Check if this is a standalone Emacs process
if [[ $(ps -p $EMACS_PID -o comm= | tr -d ' ') == "emacs" && $(ps -p $EMACS_PID -o args= | grep -v "\\-\\-daemon") ]]; then
  # Kill the current Emacs instance
  kill $EMACS_PID

  # Start a new Emacs instance with the same file
  if [[ -n "$CURRENT_FILE" ]]; then
    emacs "$CURRENT_FILE" &
  else
    emacs &
  fi

  # Optional: Wait for Emacs to start and then focus the window
  # sleep 2
  # wmctrl -a "emacs"
else
  echo "This script should only be run from a standalone Emacs instance."
fi

# Clean up the temporary file
rm /tmp/emacs_current_file.txt


exit



#########
# Notes #
#########
