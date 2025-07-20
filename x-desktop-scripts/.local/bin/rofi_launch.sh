#!/usr/bin/env bash

# rofi -modi "combi,drun,run" -combi-modi "drun,run" -show combi -debug 1

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

# Now launch rofi
rofi -modi "combi,drun,run" -combi-modi "drun,run" -show combi -monitor -1
