#/usr/bin/env zsh

#########################################################################
# Application Starter                                                   #
#                                                                       #
# AUTH: pradesigner                                                     #
# VDAT: v1 - <2023-07-31 Mon> (started around 2018)                     #
# PURP: starts applications into workspaces                             #
#                                                                       #
# The script was originally created for gnome, then adapted to          #
# leftwm. It startup a series of applications in designated tags after  #
# launching leftwm.                                                     #
#########################################################################



########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: startup apps in leftwm tags"
    echo "how: jri"
    exit
fi



#############
# Variables #
#############
#setopt sh_word_split
host=`hostnamectl hostname`
browser="vivaldi-stable"
emacser="emacsclient -c"
sleeper="sleep 3"

# comm items
gcalen="https://calendar.google.com/"
gemail="https://mail.google.com/"
pocket="https://getpocket.com/my-list"
omnivr="https://omnivore.app/home"
vivsoc="https://social.vivaldi.net/home"
aafile="~/aa/aa.org"

# praduction items
fousyn="https://fountain.io/syntax"
rhymer="https://www.rhymer.com"
thesau="https://www.thesaurus.com"
honorl="~/honor/AAmusivela.org"
tryanl="~/tryangles/AAmusivela.org"
clojure="http://localhost:1313/iknotes/computing/clojure/"
emacs="http://localhost:1313/iknotes/computing/emacs/"

# aibot items
pp="https://www.perplexity.ai"
gem="https://gemini.google.com/app"
bing="https://www.bing.com/chat"

# musivela
musiorg="~/uumusivela.org"
musivel="~/.emacs.d/musivela/musivela-mode.el"


########
# Main #
########

case $host in
    'admins')
        # start hugo server for tf
        hugo server -s ~/tf &
        
        # comm                           
        #leftwm-command "FocusPreviousTag"
        $browser $pocket $gcalen $gemail  & # start it @1
        $sleeper
        $emacser $aafile &
        $sleeper

        # praduction
        leftwm-command "FocusNextTag" # @2
        $browser --new-window $rhymer $thesau &
        $sleeper
        $emacser $honorl $tryanl &
        $sleeper

        # aibots
        leftwm-command "FocusNextTag" # @3
        leftwm-command "FocusNextTag" # @4
        leftwm-command "FocusNextTag" # @5
        $browser --new-window $pp $gem &
        $sleeper

        # # musivela
        # leftwm-command "FocusNextTag" # @6
        # leftwm-command "FocusNextTag" # @7
        # leftwm-command "FocusNextTag" # @8
        # leftwm-command "FocusNextTag" # @9
        # $emacser $musiorg $musivel &
        ;;

    
    'adagio')
        # praduction
        #leftwm-command "FocusPreviousTag"
        $browser $fousyn $rhymer $thesau &
        $sleeper
        $emacser $honorl $tryanl &
        $sleeper
        
        # lmms
        leftwm-command "FocusNextTag"
        lmms &
        $sleeper

        # move to tag 8
        for i in {3..8}; do
            leftwm-command "FocusNextTag"
        done

        # lilypond and emacs
        evince &
        $sleeper
        $emacser ~/praductions &
        $sleeper
        
        # move to tag 9
        leftwm-command "FocusNextTag"
        
        # rosegarden
        rosegarden &
        ;;
    'sonics')
        
        ;;
    'graphenril')
        
        ;;
    'mithril')
        
        ;;
    *)
        echo "Should not be here!"
        ;;    
esac



exit



#########
# Notes #
#########


# for some reason, we start in tag 1 (even though it should be 2)
# so we don't set_desktop, then set 1->2, 2->3, etc

### template ###
# label
leftwm-command "FocusNextTag"
$browser --new-window                           \

&
$sleeper
$emacser                                        \

&
$sleeper


### other setups ###

# ## hugos
# xdotool set_desktop 2
# $browser                           \
# https://gohugo.io/documentation/                \
# http://localhost:1313                           \
# &
# $sleeper
# $emacser                                        \
# ~/tf/                                           \
# &
# $sleeper


# ## prg edu
# xdotool set_desktop 3
# $browser                               \
# ~/ocs/ucate/program/clojure/Clojure-Cookbook.pdf    \
# ~/ocs/ucate/program/clojure/Clojure-Programming.pdf \
# https://clojurians.zulipchat.com/                   \
# https://zsh.sourceforge.io/Doc/Release/zsh_toc.html \
# &
# # ~/ocs/ucate/compsci/sicp.pdf
# # http://clojure-doc.org/
# # https://projecteuler.net/archives
# $sleeper
# $emacser                                        \
# ~/clj/cljedu/src/pradesigner/cc.clj                \
# ~/clj/cljedu/src/pradesigner/cp.clj                \
# &
# $sleeper


#http://crueltyfreeinvesting.org/                        \
#https://m.onlinebrokerage.cibc.com/#/signon             \

# ## clojure edu
# xdotool set_desktop 2
# $browser                                      \
# ~/ocs/ucate/program/clojure/Clojure-Cookbook.pdf           \
# ~/ocs/ucate/program/clojure/Clojure-Programming.pdf        \
# https://clojurians.zulipchat.com/                          \
# &
# eval ${xlef}
# # ~/ocs/ucate/compsci/sicp.pdf
# # http://clojure-doc.org/
# # https://projecteuler.net/archives
# $emacser                                           \
# ~/clj/cljedu/src/pradesigner/cc.clj                \
# ~/clj/cljedu/src/pradesigner/cp.clj                \
# &
# eval ${xrig}


# ## ai expts
# xdotool set_desktop 3
# $browser                                                   \
# ~/ocs/ucate/ai/data-science/doingdatascience.pdf                        \
# ~/ocs/ucate/ai/machine-learning/ML_Murphy.pdf                           \
# https://cljdoc.org/d/techascent/tech.ml.dataset/4.04/doc/readme         \
# https://scicloj.github.io/tablecloth/index.html                         \
# &
# eval ${xlef}
# $emacser                                           \
#     ~/clj/cljedu/src/pradesigner/techascent.clj    \
#     ~/clj/cljedu/src/pradesigner/tablecloth.clj    \
# &
# eval ${xrig}


# # algo trading
# xdotool set_desktop 4
# $browser                                           \
# http://developer.oanda.com/rest-live-v20/introduction           \
# https://cljdoc.org/d/techascent/tech.ml.dataset/4.04/doc/readme \
# &
# eval ${xlef}
# $emacser                                           \
# ~/algotrade/zzotes.org                          \
# ~/algotrade/oas/src/oas/                        \
# &
# eval ${xrig}


# ## $emacser zsh r edu
# xdotool set_desktop 4
# $browser                                                   \
# ~/ocs/ucate/program/linux/learninggnu$emacser_3rdedition.pdf       \
# ~/ocs/ucate/program/linux/learningshellscriptingwithzsh.pdf     \
# ~/ocs/ucate/program/R/rstudentcompanion.pdf                     \
# &
# eval ${xlef}
# $emacser                                           \
# ~/sh/zshing/zsh-scripting.pdf                   \
# ~/r/ring/r-student.r                            \
# &
# eval ${xrig}


# fxlive
# # wmctrl -s 5
# $browser \
#    https://www1.oanda.com/forex-trading/analysis/currency-heatmap \
#    https://www.oanda.com/forex-trading/analysis/forex-order-book \
#    https://www.oanda.com/forex-trading/analysis/open-position-ratios \
#    https://www.marketpulse.com \
#    https://news.oanda.com &
# $sleeper
# xdotool key super+Left
# $sleeper
# ~/bin/fxlive.sh &
# $sleeper
# xdotool key super+Right
# $sleeper


# # investing
# # wmctrl -s 2
# $browser  \
#     https://www.investorsedge.cibc.com/en/home.html \
#     https://economics.cibccm.com/economicsweb/EconomicsHome \
#     https://seekingalpha.com/ \
#     ~/ocs/ucate/trading/technique/Triumph_of_Contrarian.pdf \
#     ~/ocs/ucate/trading/technique/Contrarian_Investment_Strategies.pdf \
#     ~/ocs/ucate/trading/technical/ency_chart_patterns.pdf \
#     ~/ocs/ucate/trading/technical/trend_forecast_techan.pdf \
# #    ~/ocs/ucate/trading/fixedincome/Fixed_Income_Securities.pdf \
# #    ~/ocs/ucate/trading/fixedincome/Fixed_Income_Solutions.pdf
# $sleeper
# xdotool key super+Left
# $sleeper
# $emacser \
#     ~/ocs/ucate/trading/zzotes.org &
# $sleeper
# xdotool key super+Right
# $sleeper


# # online edu
# # wmctrl -s 3
# $browser  \
#    https://canadian-tax-academy.teachable.com/courses/39562/lectures/565914 \
#    https://school.masteringmusescore.com/courses/366102/lectures/6266985
# $sleeper
# xdotool key super+Left
# $sleeper


# # prog
# # wmctrl -s 4
# $browser  \
#      ~/ocs/ucate/program/python/pythonpacktHB/masteringpython.pdf \
#      ~/ocs/ucate/program/python/pythonnostarchHB/automate.pdf \
#      ~/ocs/ucate/program/python/python3_oop.pdf \
#      ~/ocs/ucate/program/python/functional_python_programming.pdf \
#      ~/ocs/ucate/datasci/PythonDataScienceHandbook.pdf
#      ~/ocs/ucate/program/linux/learninggnu$emacser_3rdedition.pdf \
#      ~/ocs/ucate/program/linux/learningshellscriptingwithzsh.pdf
# $sleeper
# xdotool key super+Left
# $sleeper
# $emacser \
#     ~/py/studies/automate/part1.py \
#     ~/py/studies/pdhb/ch02.py &
# $sleeper
# xdotool key super+Right
# $sleeper


# # setup fxprac
# # wmctrl -s 3
# ~/bin/fxprac.sh &
# $sleeper
# xdotool key super+Left
# $emacser \
#     ~/algotrade/apitest.py &
# $sleeper
# xdotool key super+Right


# # technical analysis
# # wmctrl -s 3
# $browser  \
#     ~/ocs/ucate/trading/technical/ency_chart_patterns.pdf \
#     ~/ocs/ucate/trading/technical/trend_forecast_techan.pdf \
#     http://thepatternsite.com/
#    #~/ocs/ucate/trading/technical/technical_analysis_A-Z.pdf
# $sleeper
# xdotool key super+Left
# $emacser \
#     ~/ocs/ucate/trading/zzotes.org &
# $sleeper


