#!/bin/bash

SEARCHSTRING="current 1366 x 768"
MODE=$(xrandr | grep -o "$SEARCHSTRING")

if [[ $MODE = $SEARCHSTRING ]]; then
    xrandr --output LVDS1 --rotate left
else
    xrandr --output LVDS1 --rotate normal
fi
