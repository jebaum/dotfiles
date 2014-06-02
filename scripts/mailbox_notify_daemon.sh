#!/bin/sh

while true
do
  /home/james/dotfiles/scripts/mailbox_notify.py &> /tmp/mailbox_notify.log
  echo "I CRASHED" >> /tmp/UHOH2
done
