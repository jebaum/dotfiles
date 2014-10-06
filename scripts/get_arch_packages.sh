#!/bin/bash

TMPFILE="/tmp/aur.html"
AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"

echo "Getting pacman packages..."
for i in /var/lib/pacman/sync/*.db; do
  name=$(basename "$i")
  name=${name%.*}
  tar -ztf $i | cut -d/ -f1 | sort -u | sed "s/^/${name}\//"; done > $PACFILE

echo "Getting aur packages..."
wget http://pkgbuild.com/git/aur-mirror.git/tree/ -O $TMPFILE
perl -nle 'print $1 if /href='"'"'\/git\/aur-mirror.git\/tree\/([^'"'"']+)/' < $TMPFILE > $AURFILE

echo "Done."
