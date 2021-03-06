#!/bin/bash

SOCKET=$HOME/.config/mpv/mpvsocket
# TYPE argument is hardcoded in ranger's rifle.conf
TYPE="$1"
shift

# don't call this script anything with mpv in the name or pgrep sees it
if pgrep mpv >/dev/null; then
  for i in "$@"; do
    echo loadfile \"$i\" append | socat - "$SOCKET" # could also do 'append-play'
  done
else
  if [[ "$TYPE" = "video" ]]; then
    mpv --force-window "$@" &>/dev/null &
  elif [[ "$TYPE" == "audio" ]]; then
    # at some point --force-window stopped working, then started again
    # if it stops again, solution is to create a playlist file using mpv --playlist=
    # newline separated, no need to escape spaces, stick it in a predefined location in /tmp
    # then, start a new terminal with the mpv command to read out of the playlist file
    nohup mpv --osd-level=3 --osd-msg3='${filename}\n${time-pos} / ${duration}\n\n${playlist}' --osd-font-size=60 --force-window --x11-name="rangermpvaudio" -- "$@" >/dev/null 2>&1 &
  fi
fi

