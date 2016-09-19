#!/bin/bash

# TODO edit and reload i3config appropriately

if [ "$#" = "1" ]; then
  selection=$1
else
  OPTIONS=(work2 work3 home2 home3 laptop mirror present)
  selection=$(IFS=$'\n'; echo "${OPTIONS[*]}" | rofi -dmenu)
fi

# TODO safeguard turning off laptop screen, only do it if other screens are actually present
if [ "$selection" = "work2" ]; then
  xrandr --output eDP-1-1 --off --output HDMI-0 --primary --mode 3440x1440 --pos 0x408 --rotate normal --output DP-6 --mode 2560x1440 --pos 3440x0 --rotate right --output DP-5 --off --output DP-4 --off --output DP-3 --off --output DP-2 --off --output DP-1 --off --output DP-0 --off
elif [ "$selection" = "work3" ]; then
  xrandr --output eDP-1-1 --off --output HDMI-0 --primary --mode 3440x1440 --pos 1440x408 --rotate normal --output DP-6 --mode 2560x1440 --pos 4880x0 --rotate right --output DP-5 --off --output DP-4 --off --output DP-3 --off --output DP-2 --mode 2560x1440 --pos 0x0 --rotate left --output DP-1 --off --output DP-0 --off
elif [ "$selection" = "home2" ]; then
  xrandr --output eDP-1-1 --off --output HDMI-0 --primary --mode 2560x1440 --pos 0x528 --rotate normal --output DP-6 --mode 2560x1440 --pos 2560x0 --rotate right --output DP-5 --off --output DP-4 --off --output DP-3 --off --output DP-2 --off --output DP-1 --off --output DP-0 --off
elif [ "$selection" = "home3" ]; then
  xrandr --output eDP-1-1 --off --output HDMI-0 --primary --mode 2560x1440 --pos 1440x504 --rotate normal --output DP-6 --mode 2560x1440 --pos 4000x0 --rotate right --output DP-5 --off --output DP-4 --off --output DP-3 --off --output DP-2 --mode 2560x1440 --pos 0x0 --rotate left --output DP-1 --off --output DP-0 --off
elif [ "$selection" = "laptop" ]; then
  xrandr --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DP-6 --off --output DP-5 --off --output DP-4 --off --output DP-3 --off --output DP-2 --off --output DP-1 --off --output DP-0 --off
elif [ "$selection" = "mirror" ]; then
  # TODO make the last command here take an input as argument, with HDMI-1 as the default
  xrandr --output $LAPTOP --primary --mode 1920x1080
  xrandr --output HDMI-1 --mode 1920x1080 --same-as $LAPTOP
elif [ "$selection" = "present" ]; then
  xrandr --output $LAPTOP --primary
  xrandr --output HDMI-1 --mode 1920x1080 --above $LAPTOP
else
  echo 'valid options: work2, work3, home2, home3, laptop, mirror, present'
fi
