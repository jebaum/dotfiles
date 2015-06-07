#!/bin/bash

### i3
cd i3
find . -maxdepth 1 -name 'i3*tar.?z' -delete
makepkg

if hash mkaurball 2>/dev/null; then
    mkaurball
else
    echo 'install pkgbuild-introspection package, provides mkaurball command'
    exit
fi

PACKAGE=$(find . -maxdepth 1 -name 'i3*tar.gz')
gpg --quiet --decrypt ../aur_login.conf.gpg > temp

if hash aurploader 2>/dev/null; then
    aurploader -l temp --auto --remove-cookiejar "$PACKAGE"
else
    echo 'install python3-aur package, provides aurploader command'
fi

shred temp
rm temp
