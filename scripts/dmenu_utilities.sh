locate "*" | dmenu | sed -e "s/'/'\\\\''/g;s/\(.*\)/'\1'/" | xargs urxvt -cd
# could easily do other things to filter this, right in the locate string

ps -fu $UID | sed 1d | dmenu -z -l 20 | awk '{print $2}' | xargs kill
# get other fkill lines from fkill.sh

