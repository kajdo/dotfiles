#!/usr/bin/env bash

# Define the directory containing the images
WALLPAPER_DIR="$HOME/Bilder/backgrounds/"

# Select a random image from the directory
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the selected image as the background using feh
feh --bg-scale "$SELECTED_WALLPAPER"

