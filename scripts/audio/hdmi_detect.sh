#!/bin/bash

CARDNUMBER=$(aplay -l | grep NVidia | grep -o -E "card ([0-9]+)" | cut -f 2 -d" " | sort -u)
DEVICENUMBERS=($(aplay -l | grep NVidia | grep -o -E "device ([0-9]+)" | cut -f 2 -d' '))
HDMINUMBER=($(aplay -l | grep NVidia | grep -o -E "HDMI ([0-9]+)" | cut -f 2 -d" " | sort -u))

# in /proc/asound/card#, where # is the card number, look at the eld files
# the one that has a bunch of info and more than two lines is the active device number
# I don't use this because pulse seems to do the right thing for the most part

echo $CARDNUMBER

for i in "${DEVICENUMBERS[@]}"; do
    echo "$i"
    if [ "$i" == "$CARDNUMBER" ]; then
        echo found it!
    fi
done

# cat > ~/dotfiles/alsaconfs/hdmi << EOF
# test $CARDNUMBER
# EOF


# cat > ~/.asoundrc << EOF
# defaults.pcm.card 2
# defaults.pcm.device 8
# defaults.pcm.card 2
# EOF
