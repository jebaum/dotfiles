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
amazon_apollo_envs      $HOME/dotfiles/scripts/amazon_apollo.sh
amazon_sellercentral    $HOME/dotfiles/scripts/amazon_scurls.sh
amazon_tools            $HOME/dotfiles/scripts/amazon_tools.sh
amazon_wiki             $HOME/dotfiles/scripts/amazon_wiki.sh
dmenu_utilities         $HOME/dotfiles/scripts/dmenu_utilities.sh
firefox_history         $HOME/dotfiles/scripts/firefox_history.sh
fzf_utilities           $HOME/dotfiles/scripts/fzf_utilities.sh
fzf.zsh                 $HOME/dotfiles/zsh/fzf.zsh
zshrc                   $HOME/dotfiles/zsh/zshrc
aliases.zsh             $HOME/dotfiles/zsh/lib/aliases.zsh
muttrc                  $HOME/dotfiles/mutt/muttrc
tmux.conf               $HOME/dotfiles/tmux.conf
vimperatorrc            $HOME/dotfiles/firefox/vimperator/vimperatorrc
Xdefaults               $HOME/dotfiles/Xdefaults"


config_file=$(echo "$myvar" | dmenu -b -i -nf \#C0C0C0 -nb \#242024 -sf \#000000 -sb \#FFA000 -fn 'Deja Vu Sans Mono-10' -l 35 | sed -e "s/ \+ / /g" | cut -f 2 -d' ')

echo $config_file
if [ -z $config_file ]; then
    echo cancelled
else
    st -e nvim "$config_file"
fi
