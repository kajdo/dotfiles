#!/usr/bin/env bash

# start picom for transparancy
set_random_wallpaper.sh &

# start dwmblocks
dwmblocks &

# start compositor
picom --config ~/.config/picom/picom.conf -b

# start dunst
dunst &

# start nm-applet
nm-applet &

# hide mousecursor if not needed
unclutter --timeout 1 &

# start blueman-applet
blueman-applet &
