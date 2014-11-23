#!/bin/bash

export PLACES_SQLITE="$HOME/.mozilla/firefox/7n3iaz0q.default/places.sqlite"

# URLS=$(sqlite3 ${PLACES_SQLITE} "SELECT url FROM moz_places;")
# sqlite3 $PLACES_SQLITE "SELECT last_visit_date,title,url FROM moz_places;" | sed -e 's/|/   /g' > /tmp/ffh.txt


# sqlite3 ~/.mozilla/firefox/n7i655jr.default/places.sqlite "SELECT printf('%s %s %s', datetime(last_visit_date/1000000, 'unixepoch', 'localtime'),title,url) FROM moz_places;"  

firefox $(sqlite3 $PLACES_SQLITE "select printf('%s %s', moz_bookmarks.title, moz_places.url) from moz_bookmarks left outer join moz_places where moz_bookmarks.fk = moz_places.id and substr(moz_places.url, 0, 5) = 'http';" | dmenu -l 50 | rev | cut -d' ' -f1 | rev)


# convert datetime to normal person time - sort by this time?
# separate fields with some useful character (maybe the default "|")
