# eval $(gpg-agent --daemon)
# NOTE: lightdm expects to see a "~/.xprofile", not "~/.xinitrc". symlink appropriately
# this seems to solve some locale/unicode display problems, first cropped up on amazon workstation
export LC_ALL=en_US.UTF-8
xset s off
xset -dpms
#xset r rate 200 70 # set in ~/.xserverrc now. 1000 / 70 = 14 milliseconds between repeats
