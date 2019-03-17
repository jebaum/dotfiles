#!/bin/bash


# cp /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist &&
# reflector --verbose --country 'United States' --latest 50 --protocol http --sort rate --save /etc/pacman.d/mirrorlist
# curl -s 'https://www.archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on'| sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

wget -O /etc/pacman.d/mirrorlist.backup https://www.archlinux.org/mirrorlist/all/ &&
rankmirrors -v -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

