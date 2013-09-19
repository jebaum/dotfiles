#!/bin/sh

while true
do
  exec /usr/bin/offlineimap &> /tmp/offlineimap.log
  echo "I CRASHED" >> /tmp/UHOH
done
