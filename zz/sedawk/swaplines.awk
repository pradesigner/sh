# #!/usr/bin/awk -f

BEGIN {RS="$"}

{
    split($0,arr,"\n")

    ## the usual array swap
    # TMP=arr[7]
    # arr[7]=arr[6]
    # arr[6]=TMP

    # swap using matches
    for (i=2;i<11;i++) {
        if (arr[i] ~ /subsubtitle/) {
            sskey = i
            skey = sskey + 1
        }
    }
    t = arr[skey]
    arr[skey] = arr[sskey]
    arr[sskey] = t

    # don't put the next two lines in END {} -> null for some reason!
    for (key in arr)
        print arr[key]
}

