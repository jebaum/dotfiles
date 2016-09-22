#!/bin/bash

xurls -r | awk '!x[$0]++' | dmenu -i -l 20 -w 1000 -centerx -centery -nf \#C0C0C0 -nb \#141214 -sf \#28F028 -sb \#303030 -fn 'Hack-12' | xargs -r qutebrowser
