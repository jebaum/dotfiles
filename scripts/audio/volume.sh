#!/bin/bash

source ${HOME}/dotfiles/scripts/audio/vars.sh

if [ "$1" == "toggle" ]; then
  amixer set $CONTROL $1
  exit
fi

if [ $# != 2 ]; then
  echo "usage: volume.sh <magnitude> <direction>"
  exit
fi

amixer -M set $CONTROL ${1}${2}

#if [ "$DEVICE" == "$XFI" ]; then # xfi has a gay scale. make it straight
  #OLDVOLUME=`amixer -M get $CONTROL | egrep -m 1 -o '[0-9]{1,3}\%{1}' | head -1 | sed s/%//`
  #VOLUME=$OLDVOLUME
  #if   [ $VOLUME == 0 -a $2 == "-" ]; then
    #exit
  #elif [ $VOLUME == 100 -a $2 == "+" ]; then
    #exit
  #fi
  #while [ $VOLUME == $OLDVOLUME ]; do
    #amixer set $CONTROL ${1}${2}
    #VOLUME=`amixer -M get $CONTROL | egrep -m 1 -o '[0-9]{1,3}\%{1}' | head -1 | sed s/%//`
  #done
#else
  #amixer -M set $CONTROL ${1}${2}
#fi

