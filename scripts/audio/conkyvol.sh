#!/bin/bash
source ${HOME}/dotfiles/scripts/audio/vars.sh


VOLUME=`amixer -M get $CONTROL | egrep -m 1 -o '[0-9]{1,3}\%{1}' | head -1`
STATUS=`amixer -M get $CONTROL | egrep -m 1 -o '\[off\]' | head -1`

if [ $STATUS == "[off]" ]; then
  SEPARATOR='m'
else
  SEPARATOR=':'
fi

echo -n ${INDICATOR}${SEPARATOR}${VOLUME}
