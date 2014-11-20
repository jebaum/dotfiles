#!/bin/bash

# vicious ugly unholy sinful hack to attempt to focus vimperator and click at the very bottom of it
# some sites like to steal keyboard focus or something unless you click somewhere. like github. idk
i3 workspace number 2:web
xdotool mousemove_relative 0 9999
xdotool click 1
