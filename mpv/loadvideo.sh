#!/bin/sh

FIFO="/home/james/.mpv/mpvfifo"
if [ ! -p "$FIFO" ]; then
  mkfifo "$FIFO"
fi

if pgrep mpv >/dev/null; then
  for i in "$@"; do
    echo loadfile \"$i\" 1 >"$FIFO"
  done
else
  mpv -input file="$FIFO" -- "$@" &>/dev/null &
  # sleep 1
  # i3-msg \[class="mplayer2"\] move workspace number 9:code
fi

