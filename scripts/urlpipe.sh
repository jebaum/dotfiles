#!/bin/bash

xurls -r | awk '!x[$0]++' | rofi -dmenu -columns 1 -width 100 -lines 20 -matching normal -monitor -2 | xargs -r firefox
