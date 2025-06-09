#!/usr/bin/env bash

# --- Configuration ---
PORTS_TO_CHECK=(
    57989 # bazzite sunshine
    47989 # fedora sunshine
    22    # Example: SSH port
    80    # Example: HTTP port
    443   # Example: HTTPS port
    # Add any other ports you need to check here
)

# --- Script Logic ---

echo "Fetching public IP address from ifconfig.co..."

# Fetch IP address from ifconfig.co/json
PUBLIC_IP=$(curl -s ifconfig.co/json | jq -r '.ip')

# Check if IP was successfully retrieved
if [ -z "$PUBLIC_IP" ]; then
    echo "Error: Could not retrieve public IP address from ifconfig.co."
    echo "Please check your internet connection or the ifconfig.co service."
    exit 1
fi

echo "Public IP Address: $PUBLIC_IP"
echo "--------------------------------------------------"

# Iterate through the array of ports and check each one
for PORT in "${PORTS_TO_CHECK[@]}"; do
    echo "Checking port $PORT..."

    # Use portchecker.io API to check if the port is open externally
    # We use -s for silent, -H for header, -d for data, and pipe to jq for parsing
    RESPONSE=$(curl -s 'https://portchecker.io/api/v1/query' \
        -H 'content-type: application/json' \
        -d "{\"host\":\"$PUBLIC_IP\",\"ports\":[\"$PORT\"]}")

    # Parse the JSON response using jq to get the 'status' value from the 'check' array
    # Corrected jq path based on your provided API response
    IS_OPEN=$(echo "$RESPONSE" | jq -r '.check[0].status')

    if [ "$IS_OPEN" == "true" ]; then
        echo -e "  \e[32mSUCCESS:\e[0m Port $PORT is \e[1mOPEN\e[0m!" # Green and bold
    else
        echo -e "  \e[31mFAIL:\e[0m Port $PORT is \e[1mCLOSED\e[0m." # Red and bold
        # For debugging, you could uncomment the next line to see the full response
        # echo "  Full response: $RESPONSE"
    fi
    echo "--------------------------------------------------"
done

echo "Port check complete."
