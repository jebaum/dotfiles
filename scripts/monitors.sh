#!/bin/bash

# 9  = leftmost
# 5  = second from left
# 2  = top middle
# 1  = bottom middle
# 6  = second from right
# 10 = rightmost

xrandr \
    --output DFP9  --mode 1920x1200 --rotate left   --pos 0x689 \
    --output DFP5  --mode 1920x1200 --rotate left   --pos 1200x689 \
    --output DFP2  --mode 2560x1440 --rotate normal --pos 2400x0 \
    --output DFP1  --mode 2560x1440 --rotate normal --pos 2400x1440 \
    --output DFP6  --mode 1920x1200 --rotate left   --pos 4960x689 \
    --output DFP10 --mode 1920x1200 --rotate left   --pos 6160x689
