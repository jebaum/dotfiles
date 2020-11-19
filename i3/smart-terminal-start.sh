#!/bin/bash

STARTUPDIR="$($HOME/dotfiles/i3/xcwd/xcwd)"

# https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
# https://stackoverflow.com/questions/14366390/check-if-an-element-is-present-in-a-bash-array  <- alternative
nonoDirs=("/run/user/1000" "/run/user/1000/firenvim" "/")
if [[ " ${nonoDirs[@]} " =~ " ${STARTUPDIR} " ]]; then
    STARTUPDIR="$HOME"
fi

STARTUPDIR="$STARTUPDIR" st
