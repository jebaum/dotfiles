#!/bin/bash

### i3
cd i3
find . -maxdepth 1 -name 'i3*tar.?z' -delete
makepkg
mkaurball
PACKAGE=$(find . -maxdepth 1 -name 'i3*tar.gz')
gpg --quiet --decrypt ../aur_login.conf.gpg > temp
aurploader -l temp --auto --remove-cookiejar "$PACKAGE"
rm temp
