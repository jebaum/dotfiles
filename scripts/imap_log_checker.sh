#!/bin/bash

# run this script every few minutes with cron
# if offlineimap has had any errors indicated by $ERRORSTRING
# kill offlineimap, and imap_daemon.sh will restart it

ERRORS=0
ERRORSTRING='ERROR:'

if [[ -e "/tmp/offlineimap.log" ]]; then
  ERRORS=$(grep -F "${ERRORSTRING}" /tmp/offlineimap.log | wc -l)
else
  echo offlineimap.log file does not exist, exiting 1>&2
  exit
fi

if [[ "${ERRORS}" == "0" ]]; then
  echo No errors found 1>&2
else
  echo "Errors found (${ERRORS})" 1>&2
  notify-send "Offlineimap: Errors found (${ERRORS}).\n Restarting..." 1>&2
  pkill offlineimap
fi
