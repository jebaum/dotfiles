#!/bin/sh

while true
do
  /usr/bin/offlineimap &> /tmp/offlineimap.log
  echo "I CRASHED" >> /tmp/UHOH
done
