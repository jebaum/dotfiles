#!/bin/sh

FIFO="/home/james/.mpv/mpvfifo"
if [ ! -p "$FIFO" ]; then
  mkfifo "$FIFO"
fi

# TYPE argument is hardcoded in ranger's rifle.conf
TYPE="$1"
shift

# don't call this script anything with mpv in the name or pgrep sees it
if pgrep mpv >/dev/null; then
  for i in "$@"; do
    echo loadfile \"$i\" 1 >"$FIFO"
  done
else
  if [[ "$TYPE" = "video" ]]; then
    mpv --force-window -input file="$FIFO" -- "$@" &>/dev/null &
  elif [[ "$TYPE" == "audio" ]]; then
    mpv --force-window --x11-name rangermpvaudio -input file="$FIFO" -- "$@" &>/dev/null &
  fi
fi

