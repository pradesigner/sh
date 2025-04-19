#!/usr/bin/env zsh
# counts page activity on sites

poohepagenames=(about supporters media kudos teachers students forum programs events gallery resources contact POONewsfirstissue POOnewslettervolume2 PO1newslettervolume3)
pooheemails=(debra@vancouverhumanesociety.bc.ca prad@towardsfreedom.com)
#sfcpagenames=(index aboutus sfcfounder programs kudos resources contact)
#sfcemails=(dani@seedsforchangehumaneeducation.org prad@towardsfreedom.com)



thecounter () {
    for page in $*; do
	print $page $(grep -c $page $logfile)
    done
}

msg="Poohe Count\n"
logfile=/var/log/apache22/vlogs/poohe-access.log


declare -A acc
while read line; do
    p=${${line##*GET /}% HTTP*}
    if [[ $p = *htm ]] || [[ $p = *html ]]; then
	(( acc[${p%.*}]+=1 ))
    fi
done < $logfile

for each in ${(ko)acc}; do
    msg+="$each $acc[$each] \n"
    (( total+=$acc[$each] ))
done

allcounts=${$(wc -l /var/log/apache22/vlogs/poohe-access.log)%%/*}
 
msg+="Total Count = $total\n"
msg+="All Counts = $allcounts\n"

print $msg | mail -s "Poohe Count" prad@towardsfreedom.com
