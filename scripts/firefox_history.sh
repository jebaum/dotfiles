#!/bin/bash

# TODO has issues with db being locked. may need to copy the file somewhere periodically and cache the results
PLACES_SQLITE="$(find $HOME/.mozilla/firefox/ -maxdepth 1 -mindepth 1 -type d -iname '*-release' | xargs du -sh | sort -rh | head -1 | cut -f2)/places.sqlite"
REPLICA_PLACES_SQLITE="/tmp/places.sqlite"
cp -f $PLACES_SQLITE $REPLICA_PLACES_SQLITE

# sqlite3 ~/.mozilla/firefox/n7i655jr.default/places.sqlite "SELECT printf('%s %s %s', datetime(last_visit_date/1000000, 'unixepoch', 'localtime'),title,url) FROM moz_places;"  

# awk field separator comes from sqliterc, which prints that unicode thingy between the url and the title
THING=$(sqlite3 -init "$HOME/dotfiles/scripts/sqliterc" $REPLICA_PLACES_SQLITE "select url,printf('%s', datetime(last_visit_date/1000000, 'unixepoch', 'localtime')),title from moz_places where substr(moz_places.url, 0, 5) = 'http'" 2>/dev/null | tac | fzf | awk -F' ━━━━➤ ' '{print $1}')

if [ -z "$THING" ]; then
    echo "you didn't select anything"
else
    firefox --new-tab "$THING"
fi
