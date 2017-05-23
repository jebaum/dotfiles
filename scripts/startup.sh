#!/bin/bash

if ! pgrep mpd > /dev/null ; then
  mpd
  mpc pause
fi

if ! pgrep ncmpcpp > /dev/null ; then
  st -c 'ncmpcpp' -e ncmpcpp &
fi

if ! pgrep mutt > /dev/null ; then
  rm -f "$HOME/.mutt/mail/selected"
  st -c 'mutt' -e mutt &
fi

if ! pgrep ranger > /dev/null ; then
  st -c 'ranger' -e ranger &
fi

if [[ $(ps aux | grep "st -c vps" | wc -l) != 2 ]]; then
  st -c vps -e zsh -c "mosh jbaumy -- zsh -c 'tmux attach -d'" &
fi
