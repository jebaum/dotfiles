#!/bin/bash
# USAGE: fkill.sh [signal [all]]

if [ "$#" -lt "1" ]; then
    SIGNAL="-9"
else
    SIGNAL=$1
    shift
fi

if [ "$1" == "all" ]; then
  pid=($(ps -ef $UID | sed 1d | fzf -m | awk '{print $2}'))
  shift
else
  pid=($(ps -fu $UID | sed 1d | fzf -m | awk '{print $2}'))
fi

if [ "x$pid" != "x" ]; then
  echo "PROCESSES TO BE KILLED"
  echo "======================"
  for p in ${pid[@]}; do
    ps -ef $UID | awk "substr(\$2, 0) == $p"
  done
  echo "======================"
  echo Killing PIDs with signal "$SIGNAL": "${pid[@]}"
  kill $SIGNAL "${pid[@]}"
fi
