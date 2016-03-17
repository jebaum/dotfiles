#!/bin/bash

PLACES_SQLITE="$(find $HOME/.mozilla/firefox/ -maxdepth 1 -mindepth 1 -type d -iname '*.default' | xargs du -sh | sort -rh | head -1 | cut -f2)/places.sqlite"

# URLS=$(sqlite3 ${PLACES_SQLITE} "SELECT url FROM moz_places;")
# sqlite3 $PLACES_SQLITE "SELECT last_visit_date,title,url FROM moz_places;" | sed -e 's/|/   /g' > /tmp/ffh.txt


# sqlite3 ~/.mozilla/firefox/n7i655jr.default/places.sqlite "SELECT printf('%s %s %s', datetime(last_visit_date/1000000, 'unixepoch', 'localtime'),title,url) FROM moz_places;"  

# THING=$(sqlite3 $PLACES_SQLITE "select moz_places.url moz_places where substr(moz_places.url, 0, 5) = 'http'" | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn -*-terminus-medium-*-*-*-14-*-*-*-*-*-*-* -l 40 | rev | cut -d' ' -f1 | rev)
# 123 in cut comes from sqliterc, which has first column width of 120. 3 spaces are added on after that
THING=$(sqlite3 -init "$HOME/dotfiles/scripts/sqliterc" $PLACES_SQLITE "select title,url from moz_places where substr(moz_places.url, 0, 5) = 'http'" 2>/dev/null | tac | dmenu -b -i -nf \#C0C0C0 -nb \#242024 -sf \#000000 -sb \#FFA000 -fn 'Deja Vu Sans Mono-10' -l 60 | cut -b 123-)
if [ -z "$THING" ]; then
    echo "you didn't select anything"
else
    firefox $THING
    # TODO actually focus a firefox window here using i3 instead of just workspace 2?
    # TODO cache the result of running the above sqlite command somewhere, and cron it every couple minutes? with long history it takes a couple seconds which is annoying
    ~/dotfiles/scripts/vimperator_hack.sh
fi

# convert datetime to normal person time - sort by this time?
# separate fields with some useful character (maybe the default "|")
