#!/bin/bash
# https://unix.stackexchange.com/questions/109900/find-prune-does-not-ignore-specified-path
# https://unix.stackexchange.com/questions/4847/make-find-show-slash-after-directories
# https://unix.stackexchange.com/questions/489857/using-find-how-to-classify-like-ls-f-directories-with-a-trailing-slash

find / \( \
-path '*.git*' -o \
-path '/usr/src/linux-headers*' -o \
-path $HOME/.cache/mesa -o \
-path $HOME/.cache/mesa_shader_cache -o \
-path $HOME/.cargo -o \
-path $HOME/.config/discord -o \
-path $HOME/.node-gyp -o \
-path $HOME/.npm -o \
-path $HOME/.nuget -o \
-path $HOME/.nvm -o \
-path $HOME/.vscode -o \
-path /dev -o \
-path /proc -o \
-path /run -o \
-path /sys -o \
-path /usr/lib/libreoffice -o \
-path /usr/lib/modules -o \
-path /usr/lib/x86_64-linux-gnu -o \
-path /usr/share/racket -o \
-path /usr/share/texmf-dist -o \
-path /usr/share/xml -o \
-path /usr/share/help-langpack -o \
-path /usr/share/icons -o \
-path /usr/share/libreoffice -o \
-path /usr/share/locale-langpack -o \
-path /usr/share/texlive -o \
-path /var/cache -o \
-path /var/lib -o \
-path /var/tmp \
\) -prune -o -type d -print 2>/dev/null | sort -u > $HOME/.cache/alldirs.txt
# below will append a trailing "/" to all directories due to implied conjunction after "-type d"
# then "-o -print" tells it to go on and print everything else that isn't caught by "-type d" normally:
# \) -prune -o -type d -printf "%p/\n" -o -print 2>/dev/null | less


find / \( \
-path '*.git*' -o \
-path '/usr/src/linux-headers*' -o \
-path $HOME/.cache/mesa -o \
-path $HOME/.cache/mesa_shader_cache -o \
-path $HOME/.cargo -o \
-path $HOME/.config/discord -o \
-path $HOME/.node-gyp -o \
-path $HOME/.npm -o \
-path $HOME/.nuget -o \
-path $HOME/.nvm -o \
-path $HOME/.vscode -o \
-path /dev -o \
-path /proc -o \
-path /run -o \
-path /sys -o \
-path /usr/lib/libreoffice -o \
-path /usr/lib/modules -o \
-path /usr/lib/x86_64-linux-gnu -o \
-path /usr/share/racket -o \
-path /usr/share/texmf-dist -o \
-path /usr/share/xml -o \
-path /usr/share/help-langpack -o \
-path /usr/share/icons -o \
-path /usr/share/libreoffice -o \
-path /usr/share/locale-langpack -o \
-path /usr/share/texlive -o \
-path /var/cache -o \
-path /var/lib -o \
-path /var/tmp \
\) -prune -o -type f -print 2>/dev/null | sort -u > $HOME/.cache/allfiles.txt

cat $HOME/.cache/allfiles.txt $HOME/.cache/alldirs.txt | sort -u > $HOME/.cache/allfilesanddirs.txt
