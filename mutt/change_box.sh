#!/bin/bash

selected="$HOME/.mutt/mail/selected"

# read box
box="$HOME/.mutt/mail/$(find $HOME/.mutt/mail -mindepth 2 -maxdepth 2 | cut -d '/' -f 6- | grep -v '^\.' | fzf)"

if [[ "$box" == "" ]]; then
    exit
fi

rm -f $selected
ln -s $box $selected
