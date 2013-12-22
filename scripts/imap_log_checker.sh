#!/bin/bash

# run this script every few minutes with cron
# if offlineimap has had any errors indicated by $ERRORSTRING
# kill offlineimap, and imap_daemon.sh will restart it

ERRORS=0
ERRORSTRING='[ALERT] Too many simultaneous connections. (Failure)'

if [[ -e "/tmp/offlineimap.log" ]]; then
  ERRORS=$(grep -F "${ERRORSTRING}" /tmp/offlineimap.log | wc -l)
else
  echo offlineimap.log file does not exist 1>&2
fi

if [[ "${ERRORS}" == "0" ]]; then
  echo No errors found
else
  echo "Errors found (${ERRORS})"
  pkill offlineimap
fi
