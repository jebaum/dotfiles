#!/bin/bash

export PLACES_SQLITE="$HOME/.mozilla/firefox/plhx7cpb.default/places.sqlite"

# URLS=$(sqlite3 ${PLACES_SQLITE} "SELECT url FROM moz_places;")
# sqlite3 $PLACES_SQLITE "SELECT last_visit_date,title,url FROM moz_places;" | sed -e 's/|/   /g' > /tmp/ffh.txt


# sqlite3 ~/.mozilla/firefox/n7i655jr.default/places.sqlite "SELECT printf('%s %s %s', datetime(last_visit_date/1000000, 'unixepoch', 'localtime'),title,url) FROM moz_places;"  

THING=$(sqlite3 $PLACES_SQLITE "select printf('%s %s', moz_bookmarks.title, moz_places.url) from moz_bookmarks left outer join moz_places where moz_bookmarks.fk = moz_places.id and substr(moz_places.url, 0, 5) = 'http';" | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn -*-terminus-medium-*-*-*-14-*-*-*-*-*-*-* -l 40 | rev | cut -d' ' -f1 | rev)

if [ -z "$THING" ]; then
    echo "you didn't select anything"
else
    firefox $THING
    ~/dotfiles/scripts/vimperator_hack.sh
fi

# convert datetime to normal person time - sort by this time?
# separate fields with some useful character (maybe the default "|")
