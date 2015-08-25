#!/bin/bash

# This will run reflector on mirrorlist, copying from backup first, overwriting

wget -O /etc/pacman.d/mirrorlist.backup https://www.archlinux.org/mirrorlist/all/ &&
cp /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist &&
reflector --verbose --country 'United States' --latest 50 --protocol http --sort rate --save /etc/pacman.d/mirrorlist
