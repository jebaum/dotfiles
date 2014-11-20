#!/bin/bash

myvar="\
i3config               $HOME/dotfiles/i3/config
vimrc                   $HOME/dotfiles/vim/vimrc
guimiromod         $HOME/dotfiles/vim/colors/guimiromod.vim
zshrc                   $HOME/dotfiles/zsh/zshrc
muttrc                 $HOME/dotfiles/mutt/muttrc
vimperatorrc       $HOME/dotfiles/firefox/vimperator/vimperatorrc
Xdefaults             $HOME/dotfiles/Xdefaults"


config_file=$(echo "$myvar" | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn "-*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*" -l 20 | sed -e "s/ \+ / /g" | cut -f 2 -d' ')

echo $config_file
if [ -z $config_file ]; then
    echo cancelled
else
    urxvt -e vim "$config_file"
fi
