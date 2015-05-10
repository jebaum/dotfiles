#!/bin/bash

AURFILE="$HOME/.aur.dat"
# PACFILE="$HOME/.pacman.dat"

# echo "Getting pacman packages..."
# for i in /var/lib/pacman/sync/*.db; do
  # name=$(basename "$i")
  # name=${name%.*}
  # tar -ztf $i | cut -d/ -f1 | sort -u | sed "s/^/${name}\//"; done > $PACFILE

# pacman -Ss | grep -E '^(community|core|extra|multilib)\/' | cut -d' ' -f 1 > $PACFILE

echo "Getting aur packages..."
# wget http://pkgbuild.com/git/aur-mirror.git/tree/ -O $TMPFILE
# perl -nle 'print $1 if /href='"'"'\/git\/aur-mirror.git\/tree\/([^'"'"']+)/' < $TMPFILE > $AURFILE

# inspired by aurpkglist command provided by python3-aur package
curl -# https://aur.archlinux.org/packages.gz | gunzip --stdout > $AURFILE
head -n 1 $AURFILE
sed -i '1d' $AURFILE

echo "Done."
