#!/bin/bash

transmission-remote -a $(xclip -o) | xargs -0 notify-send "transmission-daemon:\n $(xclip -o)"
