BASEDIR="${HOME}/.alsaconfs"
DEVICE=`readlink ${HOME}/.asoundrc | egrep -o 'hw[0-9].?[0-9]?'`
MOBO="hw0"
XFI="hw1"
HDMI="hw2.3"
HEADSET="hw4"

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
  echo "idk bro"
fi

