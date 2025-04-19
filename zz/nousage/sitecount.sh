#!/usr/bin/env zsh
# counts page activity on sites

poohepagenames=(about supporters media kudos teachers students forum programs events gallery resources contact POONewsfirstissue POOnewslettervolume2 PO1newslettervolume3)
pooheemails=(lesley@vancouverhumanesociety.bc.ca prad@towardsfreedom.com)
sfcpagenames=(index aboutus sfcfounder programs kudos resources contact)
sfcemails=(dani@seedsforchangehumaneeducation.org prad@towardsfreedom.com)



thecounter () {
    for page in $*; do
	print $page $(grep -c $page $logfile)
    done
}

#site=poohe
logfile=vlogs/poohe-access.log
#thecounter $poohepagenames

declare -A acc
while read line; do
    p=${${line##*GET /}% HTTP*}
    if [[ $p = *htm ]] || [[ $p = *html ]]; then
	(( acc[${p%.*}]+=1 ))
    fi
done < $logfile

for each in ${(ko)acc}; do
    print $each $acc[$each]
    (( total+=$acc[$each] ))
done
print
print Total Count = $total
