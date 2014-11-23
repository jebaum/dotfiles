#!/bin/bash

find -L ~ \
\( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' \
-o -path '*.git' -o -path '*.metadata' -o -path '*_notes' -o -path '*.cache/mozilla' \
-o -path '*.config/libreoffice' -o -path '*.config/chromium' -o -path '*.nv' -o -path '*.cabal' \
-o -path '*.eclipse' -o -path '*.deps' \
-o -path '*chatlogs' -o -path '*TOHS' \
-o -path '*.vim' -o -path '*.nvim' \) \
-prune -o -type d -print 2>/dev/null > ~/.cache/fzf_directories.txt


find -L ~ \
\( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' \
-o -path '*.git' -o -path '*.metadata' -o -path '*_notes' -o -path '*.cache/mozilla' \
-o -path '*.config/libreoffice' -o -path '*.config/chromium' -o -path '*.nv' -o -path '*.cabal' \
-o -path '*.eclipse' -o -path '*.deps' \
-o -path '*chatlogs' -o -path '*TOHS' \
-o -path '*.cache' -o -path '*mutt/mail' -o -path '*.neocomplete' -o -path '*.python' \
-o -path '*.thumbnails' -o -path '*Music_new' -o -path '*CBRMusic' -o -path '*storage/media' \
-o -path '*.downloads' -o -path '*.IdeaIC14' -o -path '*.adobe' \
-o -path '*vim/bundle/YouCompleteMe/third_party' \
-o -path '*.vim' -o -path '*.nvim' \) \
-prune -o -type f -print 2>/dev/null > ~/.cache/fzf_files.txt


find -L ~ \
\( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' \
-o -path '*.git' -o -path '*.metadata' -o -path '*_notes' -o -path '*.cache/mozilla' \
-o -path '*.config/libreoffice' -o -path '*.config/chromium' -o -path '*.nv' -o -path '*.cabal' \
-o -path '*.eclipse' -o -path '*.deps' \
-o -path '*chatlogs' -o -path '*TOHS' \
-o -path '*.cache' -o -path '*mutt/mail' -o -path '*.neocomplete' -o -path '*.python' \
-o -path '*.thumbnails' -o -path '*Music_new' -o -path '*CBRMusic' -o -path '*storage/media' \
-o -path '*.downloads' -o -path '*.IdeaIC14' -o -path '*.adobe' \
-o -path '*vim/bundle/YouCompleteMe/third_party' \
-o -path '*.vim' -o -path '*.nvim' \) \
-prune -o -print 2>/dev/null > ~/.cache/fzf_directories_and_files.txt
