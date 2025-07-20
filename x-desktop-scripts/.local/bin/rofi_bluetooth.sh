#!/usr/bin/env bash

#### Mouse tango to open on active screen #####
# Get the ID of the currently active window
ACTIVE_WINDOW_ID=$(xdotool getactivewindow)

# Get the geometry of the active window
# This gives you: Window X: Y: Width: Height:
WINDOW_GEOMETRY=$(xdotool getwindowgeometry --shell $ACTIVE_WINDOW_ID)

# Parse the geometry to get X, Y, Width, Height
eval "$WINDOW_GEOMETRY"

# Calculate the center of the active window
# X_CENTER = X_WINDOW + (WIDTH / 2)
# Y_CENTER = Y_WINDOW + (HEIGHT / 2)
MOUSE_X=$((X + WIDTH / 2))
MOUSE_Y=$((Y + HEIGHT / 2))

# Move the mouse to the center of the active window
xdotool mousemove "$MOUSE_X" "$MOUSE_Y"
#### Mouse tango to open on active screen #####

# Get paired devices and format for rofi (Name [MAC])
devices=$(bluetoothctl devices | awk '{name=""; for(i=3;i<=NF;i++) name=name" "$i; print name " [" $2 "]"}')

# Show rofi menu and get selected device
selected=$(echo "$devices" | rofi -dmenu -i -p "Bluetooth Device")

# Extract MAC address from selection (remove brackets and spaces)
mac=$(echo "$selected" | grep -oP '(?<=\[)[^]]+(?=\])')

# If a device was selected, connect to it
if [[ -n "$mac" ]]; then
    bluetoothctl connect "$mac"
    notify-send "Bluetooth Connected" "Device $selected connected"
fi
