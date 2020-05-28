#!/bin/bash

xurls -r | awk '!x[$0]++' | rofi -dmenu -columns 1 -width 100 -lines 20 -matching normal -location 6 | xargs -r firefox
