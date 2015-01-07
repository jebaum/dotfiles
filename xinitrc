eval $(gpg-agent --daemon)
xset s off
xset -dpms
xset s noblank
# /usr/bin/start-pulseaudio-x11
exec i3
