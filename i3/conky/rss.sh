#!/bin/bash
# Usage:
# .conkyrc: ${execi [time] /path/to/script/conky-rss.sh}
#
# Usage Example
# ${execi 300 /home/youruser/scripts/conky-rss.sh}

URI=http://feeds.feedburner.com/uclahappenings-sports-30days
LINES=2

EXEC="/usr/bin/curl -s"

$EXEC $URI | grep -i '\(title\)\|\(pubdate\)' |\
sed -e :a -e 's/<[^>]*>//g;/</N' |\
sed -e 's/[ \t]*//' |\
sed -e 's/\(.*\)/ \1/' |\
sed -e 's/\.//' |\
sed -e 's/\"//' |\
sed -e 's/\"//' |\
head -n $(($LINES * 2 + 1)) |\
tail -n $(($LINES * 2)) | dos2unix
