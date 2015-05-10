#!/bin/bash

myvar="\
i3config                       $HOME/dotfiles/i3/config
rcnarrow1                   $HOME/dotfiles/i3/conky/rcnarrow1
rcnarrow2                   $HOME/dotfiles/i3/conky/rcnarrow2
rcnarrow3                   $HOME/dotfiles/i3/conky/rcnarrow3
rcwide                         $HOME/dotfiles/i3/conky/rcwide
vimrc                           $HOME/dotfiles/vim/vimrc
guimiromod                 $HOME/dotfiles/vim/colors/guimiromod.vim
dmenu_edit_dotfiles     $HOME/dotfiles/scripts/dmenu_edit_dotfiles.sh
dmenu_utilities              $HOME/dotfiles/scripts/dmenu_utilities.sh
fzf_utilities                    $HOME/dotfiles/scripts/fzf_utilities.sh
fzf.zsh                         $HOME/dotfiles/zsh/fzf.zsh
zshrc                           $HOME/dotfiles/zsh/zshrc
aliases.zsh                   $HOME/dotfiles/zsh/lib/aliases.zsh
muttrc                         $HOME/dotfiles/mutt/muttrc
tmux.conf                    $HOME/dotfiles/tmux.conf
vimperatorrc                $HOME/dotfiles/firefox/vimperator/vimperatorrc
Xdefaults                     $HOME/dotfiles/Xdefaults"


config_file=$(echo "$myvar" | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn "-*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*" -l 20 | sed -e "s/ \+ / /g" | cut -f 2 -d' ')

echo $config_file
if [ -z $config_file ]; then
    echo cancelled
else
    urxvt -e vim "$config_file"
fi
