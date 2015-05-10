#!/bin/bash

if [ "$1" == "all" ]; then
  pid=$(ps -ef $UID | sed 1d | fzf -m | awk '{print $2}')
  shift
else
  pid=$(ps -fu $UID | sed 1d | fzf -m | awk '{print $2}')
fi

if [ "x$pid" != "x" ]; then
  echo "killing:"
  ps -ef $UID | awk "substr(\$2, 0) == $pid"
  kill -${1:-9} $pid
fi
