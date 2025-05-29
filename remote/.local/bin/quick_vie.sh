#!/usr/bin/env bash

# Define the Sunshine server IP and the name of the application
SERVER_IP="100.105.69.117" # Replace with your Sunshine server IP
APP_NAME="Desktop"         # Replace with the name of your application

# Define additional settings
FPS="60"        # Desired FPS
BITRATE="20000" # Desired bitrate in kbps -- try 8000, 16000, 32000

# Start the Moonlight-Qt connection with settings
moonlight stream "$SERVER_IP" "$APP_NAME" -fps "$FPS" -bitrate "$BITRATE" --1080 --display HDMI-2
