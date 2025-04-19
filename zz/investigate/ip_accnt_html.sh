#!/bin/sh

# ip_accnt_html.sh

# COPYRIGHT
# Copyright 2006 Peter Matulis (Papamike IT Services; papamike.ca)
# Anyone may use or modify this code for any purpose PROVIDED
# that it is recognizably derived from this code and
# that this copyright notice remains intact and unchanged.
# No warrantees of any kind are expressed or implied.


# INTRODUCTION
# This script provides basic IP accounting for a network lying
# behind an OpenBSD (3.8 or later) firewall.  It is based on the label
# feature of pf and is run at regular intervals via cron.  It uses scp/ssh
# to back up the data (it transfers the current month's statistics to
# another server) at the end of every data extraction (every invokation).
#
# In addition, there exists the option of recovering statistics for those
# systems that use mfs (or those that do not want to keep stats locally).
# These two types of scp usage are not mandatory.  You can enable or disable
# them in the variables section although you need "transfer" if you are to
# use "recovery".
#
# If recovery is used, remember to remove scp server's $MONTH directory
# if you ever wish to begin afresh.  However, the server's $YEAR directory
# must always exist.
#
# This script MUST be run at regular intervals!  After any initial testing
# period you need to ALWAYS run it using cron at the correct interval
# (see INTERVAL macro).  So delete any stale directory structure before
# using cron to run it even for the first time.


# SPECIFIC PURPOSE
# The purpose is to regularly update a file that summarizes bytes leaving
# and entering the network.  The summary file is to hold statistics
# on a monthly basis and provides totals in megabytes.  Traffic statistics
# can be related to protocol and port.  Data rates are also included.
# Every month a new directory structure is created:
#
#	/var/ip_accnt/2005/December/...
#		      2006/January/...


# DATA-TIME
# A special "tick" file is employed to determine the expired time
# associated with data totals.  This time is accrued only during a live
# internet connection.  Data rates are based on this "data-time".


# FIRST AND SECOND INVOKATIONS
# The first time the script is run we zero out the pf counters and set
# up the main directory.  The script then exits without extracting any
# data.  This is so that we do not skew our results by including data
# that might have accumulated over an unknown, and possibly very long,
# time.  This also ensures that the data extracted during the second run
# really is associated with our chosen interval.


# EXAMPLE OUTPUT
#
# ==========================================
# Host:           kovacs.domain.com
# Interface:      tun0
# Month:          December 2005
# Timestamp:      Dec 25 16:55
# Data time:      0d 18h 15m
# ==========================================
# Traffic type      Bytes-in     Bytes-out
# ------------------------------------------
# icmp:echoreq         40164         40392
# tcp:110             243937        121673
# tcp:113                  0             0
# tcp:11371                0             0
# tcp:119                  0             0
# tcp:20                   0             0
# tcp:21                   0             0
# tcp:22                   0             0
# tcp:25                9867         16736
# tcp:2703              3654          3690
# tcp:43                   0             0
# tcp:443                  0             0
# tcp:53                   0             0
# tcp:6112                 0             0
# tcp:80            12873501       3918979
# udp:123              82764         83524
# udp:53             1008118        499457
# udp:6277              8424          6628
# ------------------------------------------                          
# Total (B)         14270429       4691079
# Total (MB)          13.609         4.473
# Rate (MB/hr)          .745          .245
# ==========================================


# HTML VERSION
# This script is the advanced html version!  It creates a web page to
# display the statistics (summary.html).


# BEFORE USING THIS SCRIPT
# Create compatible pf rule labels.  This script will only
# work if labels are in the following format:
#
# 	label "inbound|outbound - <string> ->"
#
# Typical labels:
#
# 	label "inbound - $proto:$dstport ->"
# 	label "outbound - $proto:$dstport ->"
#
# This script assumes the two labels above are employed
# with pass-out (external interface) rules.
#
# Furthermore, this script assumes that the state of all
# connections are kept (i.e. 'keep state' or 'modulate state'
# are used for all pass rules you want tracked).


# DETAILS
# All data extraction is based on the output of 'pfctl -sl'.
#
# This output should look like this for, say, an outbound
# rule/label:
#
# 	outbound - tcp:25 -> 534 5583 479856 2756 316420 2827 163436
#
# Note: OpenBSD 3.7 has two columns less and that is why you
# require 3.8.  These extra columns are critical for the operation
# of this script.
#
# There are 11 columns:
#   1. label name
#   2. '-'
#   3. proto:dstport
#   4. '->'
#   5. rule evaluations
#   6. total packets in/out (columns 8 + 10)
#   7. total bytes in/out (columns 9 + 11)
#   8. packets in
#   9. bytes in
#   10. packets out
#   11. bytes out 
#
# We are interested in columns 3, 9, and 11.
#
# Important: The first four columns must be unique.
#
# Overview of determining pop3 downloads from an outbound rule:
#
# 'pfctl -sl | cut -d ' ' -f 3,9,11 | grep tcp:110' yields:
#
# 	outbound - tcp:110 -> 6726 10687 812968 5324 405380 5363 407588
#
# Because of keep/modulate state for all rules, an outbound
# rule/label is used to determine replies (downloads).  So we will
# be looking at column 9:
#
# pfctl -sl | grep tcp:110 | cut -d ' ' -f 9
# 405380
# pfctl -z
# 
# The idea is to store such a number to a variable and then manipulate it.
# After each extraction we zero out the counters (z option) so subsequent
# script runs will extract fresh (not yet counted) data.


# SETTINGS
# Adjust the next 13 variables according to your preferences.
# ---------------------------------------------------------------------------------------------------
DIR=/var/ip_accnt                                               # The main directory
PING_OBJECT=$(ifconfig tun0 | grep inet | awk '{print $4}')     # Default gateway using tun interface
#PING_OBJECT=$(route -n show | grep default | awk '{print $2}')  # Default gateway using regular interface
INTERVAL=5                                                      # Interval in minutes
SCP_RECOVERY=1                                                  # Enable=1, Disable=2
SCP_TRANSFER=1                                                  # Enable=1, Disable=2
SCP_USER=ip_accnt						# Remote SCP user
SCP_HOST=192.168.0.101						# The scp server
SCP_DIR=$DIR                                                    # The scp server's directory
SCP_KEY=/etc/ssh/ssh_user_dsa_key				# Generate with ssh-keygen (and empty password)
HEADER_BGCOLOR=dedede						# Background colour for table headers
ROW_BGCOLOR=f3f3f3						# Background colour for table rows
PORT_COLOUR=0099ff						# Text colour for port values
PORT_TOTALS_COLOUR=ff6600					# Text colour for port totals
# ---------------------------------------------------------------------------------------------------


# SCRIPT VARIABLES

HOST=$(hostname)
IF=$(pfctl -sa | grep Interface | awk '{print $4}')             # The network interface being monitored

YEAR=$(date +%Y)
MONTH=$(date +%B)
DAY=$(date +%d)
TIMESTAMP=$(date +'%b %d %R')                                   # We stamp every summary file update

IN_DIR=$DIR/$YEAR/$MONTH/bytes_in
OUT_DIR=$DIR/$YEAR/$MONTH/bytes_out

STRUCTURE_FILE=/tmp/structure					# Helps to build directory structure
TICK_FILE=$DIR/$YEAR/$MONTH/tick
TEMP1=/tmp/summary1                                             # A temporary working file (port labels)
SUMMARY=$DIR/$YEAR/$MONTH/summary.html                          # The HTML summary file


# PROCESSING COMMENCES

# Step 1 of 10
# Do we have a live internet connection?  If we do not, exit immediately.

PING=$(ping -c2 $PING_OBJECT)
RECEIVED=$(echo $PING | grep '2 packets received')

if [ "$RECEIVED" = "" ]
then
   exit 1
fi


# Step 2 of 10
# If the main directory does not exist then attempt a recovery (if enabled).

if [ ! -d $DIR ]
   then

      if [ $SCP_RECOVERY = "1" ]
         then
            mkdir -p $DIR/$YEAR
            scp -q -i $SCP_KEY -r $SCP_USER@$SCP_HOST:$SCP_DIR/$YEAR/$MONTH $DIR/$YEAR
      fi

fi


# Step 3 of 10
# Check whether we should begin counting for a new month.  If we do,
# create a new directory structure, zero the counters, and exit.

pfctl -sl | grep -E 'inbound|outbound' | cut -d ' ' -f 3  | sort -u > $STRUCTURE_FILE
echo TOTAL_PORTS >> $STRUCTURE_FILE
echo TOTAL_IPS >> $STRUCTURE_FILE

if [ ! -d $DIR/$YEAR/$MONTH ]
then

   mkdir -p $DIR/$YEAR/$MONTH
   touch $TICK_FILE
   echo 1 > $TICK_FILE

   for i in $IN_DIR $OUT_DIR
   do
      mkdir $i
      cd $i   
      while read LABEL
      do              
         touch $LABEL
         echo 0 > $LABEL
      done < $STRUCTURE_FILE

   done

   pfctl -qz
   exit 1 

fi


# Step 4 of 10
# Check if any new labels have been created since the current month's
# structure has been set up.  If they have, create its two files and
# assign a value of zero to them.

for i in $IN_DIR $OUT_DIR
do
  
   cd $i
   while read LABEL
   do
      if [ ! -f $LABEL ]
      then            
         echo 0 > $LABEL
      fi                
   done < $STRUCTURE_FILE

done


# Step 5 of 10
# Define more variables

# Ports going in
TOTAL_PORTS_IN_FILE=$IN_DIR/TOTAL_PORTS
TOTAL_PORTS_IN=$(cat $IN_DIR/TOTAL_PORTS)

# Ports going out
TOTAL_PORTS_OUT_FILE=$OUT_DIR/TOTAL_PORTS
TOTAL_PORTS_OUT=$(cat $OUT_DIR/TOTAL_PORTS)

TICKS=$(cat $TICK_FILE)

# Prepare the data-time to be displayed in this format: '5d 12h 35m'
DATA_TIME=$(expr $TICKS \* $INTERVAL)                   	# Total minutes
DATA_TIME_DAYS=$(expr $DATA_TIME / 1440)                	# Number of days
DATA_TIME_DAYS_rem=$(expr $DATA_TIME % 1440)            	# Number of minutes not included in full days
DATA_TIME_HOURS=$(expr $DATA_TIME_DAYS_rem / 60)        	# Number of hours not included in full days
DATA_TIME_HOURS_rem=$(expr $DATA_TIME_DAYS_rem % 60)    	# Number of minutes not included in full days or full hours
DATA_TIME_MINUTES=$DATA_TIME_HOURS_rem
DATA_TIME_FORMATED=""$DATA_TIME_DAYS"d "$DATA_TIME_HOURS"h "$DATA_TIME_MINUTES"m"


# Step 6 of 10
# Extract stats and store them to disk

# iterate through outbound and inbound labels
for i in outbound inbound
do

   # construct a file containing port labels
   pfctl -sl | grep $i | cut -d ' ' -f 3 | sort > $DIR/$YEAR/$MONTH/"$i"_port_labels

   while read LABEL
   do

      # inbound stats (column 9; bytes in)
      PORT_IN=$(pfctl -sl | grep $i | grep $LABEL | cut -d ' ' -f 9)
      PORT_IN_SUM=$(cat $IN_DIR/$LABEL)
      PORT_IN_SUM=$(expr $PORT_IN_SUM + $PORT_IN)
      echo $PORT_IN_SUM > $IN_DIR/$LABEL
      TOTAL_PORTS_IN=$(expr $TOTAL_PORTS_IN + $PORT_IN)
      echo $TOTAL_PORTS_IN > $TOTAL_PORTS_IN_FILE

      # outbound stats (column 11; bytes out)
      PORT_OUT=$(pfctl -sl | grep $i | grep $LABEL | cut -d ' ' -f 11)
      PORT_OUT_SUM=$(cat $OUT_DIR/$LABEL)
      PORT_OUT_SUM=$(expr $PORT_OUT_SUM + $PORT_OUT)
      echo $PORT_OUT_SUM > $OUT_DIR/$LABEL                      
      TOTAL_PORTS_OUT=$(expr $TOTAL_PORTS_OUT + $PORT_OUT)
      echo $TOTAL_PORTS_OUT > $TOTAL_PORTS_OUT_FILE

   done < $DIR/$YEAR/$MONTH/"$i"_port_labels

done

TOTAL_PORTS_IN_MB=$(echo "scale=3; $TOTAL_PORTS_IN / (1024 * 1024)" | bc)
TOTAL_PORTS_OUT_MB=$(echo "scale=3; $TOTAL_PORTS_OUT / (1024 * 1024)" | bc)

DATA_TIME_RATE_IN=$(echo "scale=3; ($TOTAL_PORTS_IN * 60) / ($DATA_TIME * 1024 * 1024)" | bc)
DATA_TIME_RATE_OUT=$(echo "scale=3; ($TOTAL_PORTS_OUT * 60) / ($DATA_TIME * 1024 * 1024)" | bc)


# Step 7 of 10
# Clear the counters to get ready for next run
pfctl -qz


# Step 8 of 10
# Build the summary file

#    Begin with an empty temp file
cat /dev/null > $TEMP1

#    Define a file containing all unique labels (inbound & outbound)
ALL_PORT_LABELS_FILE=$DIR/$YEAR/$MONTH/all_port_labels

#    Set up opening HTML lines and table for top portion of the stats board
cat > $SUMMARY << HERE
<HTML>
<HEAD>
<TITLE>ip_accnt_html.sh</TITLE>
</HEAD>
<BODY>
<TABLE BORDER=1>
<TR><TD width=120 bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Host:</B></FONT></TD><TD width=205>$HOST</TD></TR>
<TR><TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Interface:</B></FONT></TD><TD>$IF</TD></TR>
<TR><TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Month:</B></FONT></TD><TD>$MONTH $YEAR</TD></TR>
<TR><TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Timestamp:</B></FONT></TD><TD>$TIMESTAMP</TD></TR>
<TR><TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Data time:</B></FONT></TD><TD>$DATA_TIME_FORMATED</TD></TR>
</TABLE>
<BR>
HERE

#    Add table for port labels
cat >> $SUMMARY << HERE
<TABLE BORDER=1>
<TR>
<TD width=120 bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Traffic type</B></FONT></TD>
<TD width=100 bgcolor=$HEADER_BGCOLOR align=right><FONT size=2><B>Bytes-in</B></FONT></TD>
<TD width=100 bgcolor=$HEADER_BGCOLOR align=right><FONT size=2><B>Bytes-out</B></FONT></TD>
</TR>
HERE

pfctl -sl | grep -E 'inbound|outbound' | cut -d ' ' -f 3  | sort -u > $ALL_PORT_LABELS_FILE

while read LABEL
do

   IN_LABEL=$(cat $IN_DIR/$LABEL)
   OUT_LABEL=$(cat $OUT_DIR/$LABEL)
   LINE="<TR>
	 <TD bgcolor=$ROW_BGCOLOR><FONT size=2>$LABEL</FONT></TD>
	 <TD align=right><FONT size=2 color=$PORT_COLOUR><B>$IN_LABEL</B></FONT></TD>
	 <TD align=right><FONT size=2 color=$PORT_COLOUR><B>$OUT_LABEL</B></FONT></TD>
	 </TR>"
   echo "$LINE" >> $SUMMARY

done < $ALL_PORT_LABELS_FILE

cat >> $SUMMARY << HERE
<TR>
<TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Total (B)</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$TOTAL_PORTS_IN</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$TOTAL_PORTS_OUT</B></FONT></TD>
</TR>
<TR>
<TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Total (MB)</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$TOTAL_PORTS_IN_MB</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$TOTAL_PORTS_OUT_MB</B></FONT></TD>
</TR>
<TR>
<TD bgcolor=$HEADER_BGCOLOR><FONT size=2><B>Rate (MB/hr)</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$DATA_TIME_RATE_IN</B></FONT></TD>
<TD align=right><FONT size=2 color=$PORT_TOTALS_COLOUR><B>$DATA_TIME_RATE_OUT</B></FONT></TD>
</TR>
</TABLE>

<BR>

<TABLE cellpadding = "5">
<TR><TD colspan = "2"><b>Common ports</b></TD></TR>
<TR>
   <TD>tcp:25</TD>
   <TD>-> smtp (sending email)</TD>
</TR>    
<TR>
   <TD>tcp:80</TD>  
   <TD>-> http (regular web)</TD>
</TR>    
<TR>
   <TD>tcp:110</TD>
   <TD>-> pop3 (retrieving email)</TD>
</TR>    
<TR>
   <TD>tcp:443</TD>
   <TD>-> https (encrypted web)</TD>
</TR>    
<TR>
   <TD>tcp:3389</TD>
   <TD>-> MS remote desktop</TD>
</TR>     
<TR>
   <TD>udp:53</TD>
   <TD>-> dns (resolving domains)</TD>
</TR>
</TABLE>

</BODY>
</HTML>
HERE


# Step 9 of 10
# Increment the tick file for the next run.

TICKS=$(expr $TICKS + 1)
echo $TICKS > $TICK_FILE


# Step 10 of 10
# Make the scp transfer for the current month (if enabled).

if [ $SCP_TRANSFER = "1" ]
then
   scp -q -i $SCP_KEY -r $DIR/$YEAR/$MONTH $SCP_USER@$SCP_HOST:$SCP_DIR/$YEAR
fi
