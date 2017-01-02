#!/bin/bash

# https://blog.sarine.nl/blog/2014/08/03/rofi-updates/

if [[ -z $@ ]]; then
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
else
    WORKSPACE=$@
    i3-msg workspace "${WORKSPACE}" >/dev/null
fi
