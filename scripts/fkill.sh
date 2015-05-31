#!/bin/bash

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
  kill -${1:-9} $pid
  echo "done"
fi
