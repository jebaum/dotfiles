#!/bin/sh

proc="journalctl /usr/sbin/sshd -fl"

exec $proc | while read line
do
  echo $line | grep 'Accepted publickey for root' && notify-send -t 3000 'root logged in'
done
