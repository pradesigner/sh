#!/usr/bin/env zsh

if [[ $1 == '-h' ]]; then
    echo "use: sets up some of tfsite from old html"
    echo "how: jri"
    exit
fi

# forgot what this program is for TODO
# changed the archetypes/default.md to .org with toml code.

# * initializations
I=index.org

wrt=tf/2.html
rtc=tf/3.html
ssa=tf/4.html
thn=tf/5.html
lnk=tf/6.html
bra=tf/7.html
ctv=tf/9.html

# * grab tle|dsc|txt from an html page
tle-from-page() {
    # gets the title from the actual page's html
    hxselect -c title <$1 | tr " " "-"

    # alternatives
    #sed -n 's/  <title>\(.*\)<\/title>/\1/p' $1 | tr " " "-"
    #awk 'BEGIN {RS="$"; FS="<title>|</title>"} {print $2}' $1 | tr " " "-"
}

dsc-from-page() {
    # gets the dsc from the actual page's html
    hxselect -s "\n" meta <$1 | sed -n '/description/p' | hxselect -c 'meta::attr(content)'

    # alternatives
    # awk 'BEGIN {RS="$"; FS="<meta name=\"description\" content="} {print $2}' $1 |\
        #     awk 'BEGIN {RS="$"; FS="\""} {print $2}'
    # hxselect -s "\n" meta <$1 | sed -n '/description/p' | sed -n 's/^.*content="\(.*\)".*$/\1/p'
}

key-from-page() {
    # gets the keywords from page, specifically wherns
    hxselect -s "\n" meta <$1 | sed -n '/keywords/p' | hxselect -c 'meta::attr(content)'    
}

txt-from-page() {
    # gets the txt from the actual page's html
    hxnormalize -xe <$1 |\
    hxselect p |\
        hxremove p:first-child, p.hdr, p.dsc, p.spc, p.artmsbytle, p.artmsbydsc |\
        html2text

    # alternatives
    #html2text $1 | sed '1,20'd | sed '/Irtcles by/,$'d #simpler, but more rigid
}

mkarrs() {
    # makes the tle,dsc,aut,url,pic arrays
    tleA=("${(@s/XXX/)$(hxselect -s XXX -c p.secitmtle < $1)}")
    dscA=("${(@s/XXX/)$(hxselect -s XXX -c p.secitmdsc < $1)}")
    autA=("${(@s/XXX/)$(hxselect -s XXX -c p.secitmaut < $1)}")
    catA=("${(@s/XXX/)$(hxselect -s XXX -c p.whern < $1)}")
    urlA=("${(@s/XXX/)$(hxselect -s XXX -c 'p.secitmurl a::attr(href)' < $1)}")
    picA=("${(@s/XXX/)$(hxselect -s XXX -c 'img.floatrig::attr(src)' < $1)}")
}

# * setup-dirs
setup-dirs() {
    # sets up the directories with empty _index.org files
    hugo new _$I
    sed -i\
        -e 's/DSC/"Ittract! Ixplore! Injoy!"/'\
        -e 's/CATS//'\
        -e 's/TAGS//'\
        content/_$I
    
    declare -A L1dscs
    L1dscs=( Iabbers "Instruments Ixpediting Ideas!"
             Ibrarys "Irchives Illuminating Imnds!"
             Ictvity "Ingaging Interprising Iveliness!"
             Iknotes "Investigations Into Ixistence!"
             Insites "Ibserving Interesting Ireas!"
             Ithngys "Ilightful Inticing Items!"
             Iwrters "Irtcle Iarchtects Icquaintance!" )
    
    for d in Iabbers Ibrarys Ictvity Iknotes Insites Ithngys Iwrters; do
        hugo new $d/_$I
        sed -i "s/DSC/$L1dscs[$d]/" content/$d/_$I
        sed -i\
            -e 's/CATS//'\
            -e 's/TAGS//'\
            content/$d/_$I
    done

    
    declare -A L1dirs
    L1dirs=( Iabbers "Chat Forum THLogs blOOks eLetters"
             Ibrarys "Books Papers Podcasts Videos"
             Ictvity "Chess CritterCavern Ethology Haven Music Photography AI Pranktuary"
             Iknotes "Computing Engineering Health Logic Music"
             Insites "Beings Discourse Games Learning Organizations"
             Ithngys "Business Items Products Services" )

    #Iabbers, Ibrarys, Ictvity, Iknotes, Insites, Ithngys
    for L1 in Iabbers Ibrarys Ictvity Iknotes Insites Ithngys; do
        for L2 in ${(z)L1dirs[$L1]}; do #using z parameter expansion (echo also works)
            hugo new $L1/$L2/_$I
            sed -i\
                -e "s/AUT/prauthor/"\
                -e "s/DSC/$L2/"\
                -e "s/CATS//"\
                -e "s/TAGS//"\
                content/$L1/$L2/_$I
        done
    done
}


# * Iwrter authors and their articles
# ** setup authors
setup-authors() {
    mkarrs $wrt
    
    let "N = $#tleA - 1"
    for i in {1..$N}; do
        #form autD name from tle
        autD=$(echo $tleA[$i] | tr " " "-")
        
        #create autD's _index.org
        hugo new Iwrters/$autD/_$I

        #put in author's pic
        pic=$picA[$i]
        cp tf/$pic content/Iwrters/$autD/00.jpg

        #substitute for dsc,aut and remove cats and tags
        sed -i\
            -e "s/DSC/$dscA[$i]/"\
            -e "s/AUT/$tleA[$i]/"\
            -e 's/CATS//'\
            -e 's/TAGS//'\
            content/Iwrters/$autD/_$I

        #append author txt
        url=$urlA[$i]
        if [[ $url = http* ]]
        then
            txt="TBA"
        else
            txt=$(txt-from-page tf/$url)
        fi
        echo $txt >> content/Iwrters/$autD/_$I
    done
}

# ** setup articles
setup-articles() {
    mkarrs $rtc

    let "N = $#tleA - 1"
    for i in {1..$N}; do
        #form autD from aut
        autD=$(echo $autA[$i] | tr " " "-")

        #form tle of article
        tleD=$(echo $tleA[$i] |\
                   tr -d "\n" |\
                   sed -e "s/[:,']//g" -e "s/\.\{3\}/ /g" -e "s/ \{2,\}/ /"|\
                   tr " " "-")

        #form the dsc
        dsc=$(echo $dscA[$i] |\
                  tr -d "\n" |\
           sed -e "s/ \{2,\}/ /")

        #form the whern categories
        cat=$(echo $catA[$i] | tr " " ",")
        
        #create the article
        hugo new Iwrters/$autD/$tleD/index.org

        #put in article pic
        cp tf/$picA[$i] content/Iwrters/$autD/$tleD/00.jpg

        #substitute for dsc,aut,cat
        sed -i\
            -e "s/DSC/$dsc/"\
            -e "s/AUT/$autA[$i]/"\
            -e "s/CATS/$cat/"\
            content/Iwrters/$autD/$tleD/$I

        #append article txt
        url=$urlA[$i]
        if [[ $url = http* ]]
        then
            txt="TBA"
        else
            txt=$(txt-from-page tf/$url)
        fi
        echo $txt >> content/Iwrters/$autD/$tleD/$I

    done
}

## from 3.html: get tle, dsc, lnk -> txt
## place into proper iwrter dir


# * main
setup-dirs
setup-authors
setup-articles

exit


# * notes

: ' Iwrters structure
Iwrters/
    _index.org
    00.pic
    author/
        _index.org
        00.pic
        article/
            index.org
            00.pic
'

# # remove all WHERNSTO from the _index.org files since these are never substituted for
# sed -i 's/WHERNSTO//' $(find ./content/ -name "_index.org")

# pic array
# local picstr=$(sed -n 's/<img class=\"floatrig\" src=\"\(.*\)\" w.*/\1*/p' $wrt)
# picarr=(${(@s:*:)picstr})

# ## tle array
# tleA=( $(sed -n 's/<p class="secitmtle">\(.*\)<\/p>/\1/p' $wrt) )

# ## dsc array
# dscA=( $(sed -n 's/<p class="secitmdsc">\(.*\)<\/p>/\1/p' $wrt) )

# ## url array for iwrters
# urlA=( $(sed -n 's/.*href=\"\(.*\)">see.*/\1/p' $wrt) )

# hxselect 'meta[name="description"]' < 294.html | grep -Po '(?<=content=").+(")'

# echo 'some text here:11' | grep -Po '(?<=here:)\d+'
# 11
# echo 'some text here:apple' | grep -Po '(?<=here:)\w+'
# apple

# hxselect -s "\n" img.floatrig <2.html | grep -oP '(src=\").+?(\")'
# hxselect -s "\n" img.floatrig <2.html | grep -oP '(?<=src=").*?"' | sed 's/"//'

# works well
# hxselect -s "\n" img.floatrig <2.html | tr '"' ',' | awk -F, '{print $4}'
# hxselect -s "\n" img.floatrig <2.html | awk -F\" '{print $4}'

# gets the entire meta tag which matches descrip
# hxselect -s "\n" meta <tf/294.html | sed -n '/descrip/p'
# <meta name="description" content="The delightful Hindu story of a somewhat creative way to salvation."></meta>

# selects out the content from the meta tag matching descrip
# hxselect -s "\n" meta <tf/294.html | sed -n '/descrip/p' | hxselect -c 'meta::attr(content)'
# The delightful Hindu story of a somewhat creative way to salvation.

# gets the content out of all the meta tags and then picks the 5th one (works in this case)
# hxselect -cs "\n" 'meta::attr(content)' <tf/294.html | sed -n 5p
# The delightful Hindu story of a somewhat creative way to salvation.

