#!/bin/bash

if ! pgrep mpd > /dev/null ; then
  mpd
  mpc pause
fi

if ! pgrep ncmpcpp > /dev/null ; then
  urxvt -name ncmpcpp -e ncmpcpp &
fi

if ! pgrep mutt > /dev/null ; then
  urxvt -name mutt    -e mutt &
fi

if ! pgrep ranger > /dev/null ; then
  EDITOR=vim urxvt -name ranger -e ranger &
fi

if [[ $(ps aux | grep "urxvt -name vps" | wc -l) != 2 ]]; then
  urxvt -name vps -e zsh -c "mosh james@jbaumy.com" &
fi
