#!/bin/bash

AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"

# for i in /var/lib/pacman/sync/*.db; do
  # name=$(basename "$i")
  # name=${name%.*}
  # tar -ztf $i | cut -d/ -f1 | sort -u | sed "s/^/${name}\//"; done > $PACFILE

echo "Getting pacman packages..."
pacman -Ss | grep -E '^(community|core|extra|multilib)\/' | cut -d' ' -f 1 > $PACFILE

echo "Getting aur packages..."
# wget http://pkgbuild.com/git/aur-mirror.git/tree/ -O $TMPFILE
# perl -nle 'print $1 if /href='"'"'\/git\/aur-mirror.git\/tree\/([^'"'"']+)/' < $TMPFILE > $AURFILE

# inspired by aurpkglist command provided by python3-aur package
IFS=' ' AURLIST=$(curl --progress-bar https://aur.archlinux.org/packages.gz | gunzip --stdout 2>/dev/null)
if [ "$?" = "1" ]; then
    echo "could not get aur package list. bad connection?"
else
    cat <<< $AURLIST > "$AURFILE"
fi
head -n 1 $AURFILE
sed -i '1d' $AURFILE

echo "Done."
