#!/bin/bash

#xrandr --output VGA-0   --pos 0x0
#xrandr --output DVI-D-0 --pos 1920x200
#xrandr --output DVI-D-1 --pos 3840x200

if [ "$1" == "on" ]; then
  xrandr --output HDMI-0  --auto
  #xrandr --output HDMI-0  --pos 5760x200
  xrandr --output HDMI-0  --right-of DVI-D-1
elif [ "$1" == "off" ]; then
  xrandr --output HDMI-0  --off
else
  echo "unrecognized option"
fi
