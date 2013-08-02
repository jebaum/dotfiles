#!/bin/sh

FIFO="/home/james/.mplayer/mplayerfifo"
if [ ! -p "$FIFO" ]; then
  mkfifo "$FIFO"
fi

if pgrep mplayer >/dev/null; then
  for i in "$@"; do
    echo loadfile \"$i\" 1 >"$FIFO"
  done
else
  mplayer -input file="$FIFO" -- "$@" &>/dev/null &
fi

