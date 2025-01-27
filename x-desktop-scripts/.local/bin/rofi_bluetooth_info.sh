#!/usr/bin/env bash

# Get connected Bluetooth devices
connected_devices=$(bluetoothctl devices Connected | awk '{name=""; for(i=3;i<=NF;i++) name=name" "$i; print name " [" $2 "]"}')

# If no devices are connected, show a notification and exit
if [[ -z "$connected_devices" ]]; then
    notify-send "Bluetooth Info" "No devices currently connected"
    exit 0
fi

# Show rofi menu and get selected device
selected=$(echo "$connected_devices" | rofi -dmenu -i -p "Select Bluetooth Device")

# Extract MAC address from selection (remove brackets and spaces)
mac=$(echo "$selected" | grep -oP '(?<=\[)[^]]+(?=\])')

# If a device was selected, get its profile information
if [[ -n "$mac" ]]; then
    # Get the active profile using wpctl
    profile=$(wpctl status | grep -A10 "Audio" | grep "Bluetooth" -A5 | grep "profile:" | awk '{print $2}')
    
    # Translate profile to human-readable format
    case "$profile" in
        a2dp_sink)
            profile_name="High Quality Stereo (A2DP)"
            ;;
        headset_head_unit)
            profile_name="Headset with Microphone (HSP/HFP)"
            ;;
        *)
            profile_name="Unknown Profile"
            ;;
    esac
    
    # Send notification with connection info
    notify-send "Bluetooth Device Info" \
        "Device: $selected\nProfile: $profile_name"
fi
