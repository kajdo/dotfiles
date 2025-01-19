#!/usr/bin/env bash

# Starts when DWM is initialy loaded
set_random_wallpaper.sh &

# start dwmblocks
dwmblocks &

# start compositor
picom --config ~/.config/picom/picom.conf -b

# start dunst
dunst &
