#!/bin/bash

if [ "$1" == "all" ]; then
  pid=$(ps -ef $UID | sed 1d | fzf -m | awk '{print $2}')
  shift
else
  pid=$(ps -fu $UID | sed 1d | fzf -m | awk '{print $2}')
fi

if [ "x$pid" != "x" ]; then
  kill -${1:-9} $pid
fi
