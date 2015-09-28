#!/bin/bash

selected="$HOME/.mutt/mail/selected"

# TODO - make this more robust
box="$HOME/.mutt/mail/$(find $HOME/.mutt/mail -mindepth 2 -maxdepth 2 | cut -d '/' -f 6- | grep -v '^\.' | fzf)"

rm -f $selected

ln -s $box $selected
