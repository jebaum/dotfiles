#!/bin/bash

myvar="\
i3config                $HOME/dotfiles/i3/config
rcnarrow1               $HOME/dotfiles/i3/conky/rcnarrow1
rcnarrow2               $HOME/dotfiles/i3/conky/rcnarrow2
rcnarrow3               $HOME/dotfiles/i3/conky/rcnarrow3
rcwide                  $HOME/dotfiles/i3/conky/rcwide
vimrc                   $HOME/dotfiles/vim/vimrc
guimiromod              $HOME/dotfiles/vim/colors/guimiromod.vim
dmenu_edit_dotfiles     $HOME/dotfiles/scripts/dmenu_edit_dotfiles.sh
dmenu_utilities         $HOME/dotfiles/scripts/dmenu_utilities.sh
firefox_history         $HOME/dotfiles/scripts/firefox_history.sh
fzf_utilities           $HOME/dotfiles/scripts/fzf_utilities.sh
fzf.zsh                 $HOME/dotfiles/zsh/fzf.zsh
zshrc                   $HOME/dotfiles/zsh/zshrc
aliases.zsh             $HOME/dotfiles/zsh/aliases.zsh
muttrc                  $HOME/dotfiles/mutt/muttrc
tmux.conf               $HOME/dotfiles/tmux.conf
vimperatorrc            $HOME/dotfiles/firefox/vimperator/vimperatorrc
qutebrowser.conf        $HOME/dotfiles/config/qutebrowser/qutebrowser.conf
keys.conf               $HOME/dotfiles/config/qutebrowser/keys.conf
Xdefaults               $HOME/dotfiles/Xdefaults"


config_file=$(echo "$myvar" | rofi -dmenu -i -width 100 -location 6 | sed -e "s/ \+ / /g" | cut -f 2 -d' ')

echo $config_file
if [ -z $config_file ]; then
    echo cancelled
else
    st -e nvim "$config_file"
fi
