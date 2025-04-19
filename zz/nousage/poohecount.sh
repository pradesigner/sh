#!/usr/local/bin/zsh
# counts page activity on poohe site

#rc=1

poohepagenames=(about supporters media kudos teachers students forum programs events gallery resources contact POONewsfirstissue POOnewslettervolume2 PO1newslettervolume3)
emails=(debra@vancouverhumanesociety.bc.ca prad@towardsfreedom.com)

#logfile=/var/log/lighttpd/vlogs/poohe-access.log
logfile=/home/pradmin/vlogs/poohe-access.log
date=`date`
msg="Poohe Count generated $date\n\n"

#cuts the 7th item produced by splitting each line by spaces and put into string lines
lines=`cut -d ' ' -f 7 $logfile`

#typeset seems to be necessary instead of just set to get acc to be an accummulative array
typeset -A acc

#splits the string lines using (f) flag into newlines
#isolates the pagename
#checks to see if the pagename matches contents of poohepagenames using (M) flag
#accummulates counts in associative array acc by pagename 
for line in ${(f)lines};do
    pagename=${${line##*/}%.*}
    if [[ ${#${(M)poohepagenames:#$pagename}} -eq 1 ]];then
	(( acc[$pagename]+=1 ))
    fi
done

#sorts the keys in acc using the (ko) flags, calculates the totals and stores in msg
for each in ${(ko)acc};do
    msg+="$each $acc[$each] \n"
    (( total+=$acc[$each] ))
done

allcounts=${$(wc -l $logfile)%%/*}
msg+="\nTotal is $total\nAll counts is $allcounts\n"

echo $msg | mail -s "Poohe Count for $date" $emails

#exit $rc
