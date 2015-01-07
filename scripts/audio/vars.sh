# note to self - this counts on existing link being valid or some shit. look into that
BASEDIR="${HOME}/dotfiles/alsaconfs"
DEVICE=`readlink -f ${HOME}/.asoundrc`  # | egrep -o 'hw[0-9].?[0-9]?'`
MOBO="${BASEDIR}/mobo"
XFI="${BASEDIR}/xfi"
HDMI="${BASEDIR}/hdmi"
HEADSET="${BASEDIR}/headset"

if   [ "$DEVICE" == "$MOBO" ]; then
  INDICATOR="M"
  CONTROL="Master"

elif [ "$DEVICE" == "$XFI" ]; then
  INDICATOR="X"
  CONTROL="Front"

elif [ "$DEVICE" == "$HDMI" ]; then
  INDICATOR="T"
  CONTROL="fuck"

elif [ "$DEVICE" == "$HEADSET" ]; then
  INDICATOR="H"
  CONTROL="PCM"

else
  # assume pulse for now
  # TODO need to find out the name of the current default sink and set the indicator
  # pactl list short sinks, pactl list short sink-inputs
  INDICATOR="P"
  CONTROL="Master"
fi

