eval $(gpg-agent --daemon)
xset s off
xset -dpms
xset s noblank
#xset r rate 200 70 # set in ~/.xserverrc now. 1000 / 70 = 14 milliseconds between repeats
start-pulseaudio-x11

xrandr \
    --output DP-3   --mode 2560x1440 --pos 0x0      --rotate left \
    --output DP-1   --mode 2560x1440 --pos 1440x0   --rotate left \
    --output HDMI-1 --mode 2560x1440 --pos 2880x552 --rotate normal --primary \
    --output DP-2   --mode 2560x1440 --pos 5440x0   --rotate right \
    --output DVI-D-1 --off
exec i3
