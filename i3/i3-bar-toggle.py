#!/usr/bin/env python3

# https://github.com/acrisci/i3ipc-python
# https://aur.archlinux.org/packages/i3ipc-python-git
# last I tried, the aur package was broken. had to use pip

import i3ipc

conn = i3ipc.Connection()
bar0conf = conn.get_bar_config("bar-0")

if bar0conf.mode == "dock":
    conn.command("bar mode hide")
else:
    conn.command("bar mode dock")
