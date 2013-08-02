#!/bin/bash
source ${HOME}/dotfiles/scripts/audio/vars.sh

function rmifexists()
{
  if [ -e ${HOME}/.asoundrc ]; then
    rm ${HOME}/.asoundrc
  fi
}

if   [ "$1" == "mobo" ]; then
  rmifexists
  ln -s ${BASEDIR}/${MOBO} ${HOME}/.asoundrc
  amixer set PCM 209

elif [ "$1" == "xfi" ]; then
  rmifexists
  ln -s ${BASEDIR}/${XFI} ${HOME}/.asoundrc
  amixer set PCM 211
  amixer set Master 256

elif [ "$1" == "hdmi" ]; then
  rmifexists
  ln -s ${BASEDIR}/${HDMI} ${HOME}/.asoundrc

elif [ "$1" == "headset" ]; then
  rmifexists
  ln -s ${BASEDIR}/${HEADSET} ${HOME}/.asoundrc

else
  echo "valid device options are: mobo, xfi, hdmi, headset"
fi

