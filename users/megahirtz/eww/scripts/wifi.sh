#!/bin/sh
if nmcli c show --active | grep -q "ethernet"; then
    icon=""
    device=$(nmcli d status | awk '/ethernet/{ print $1}')
    status="Connected to $device"
elif nmcli c show --active | grep -q "wifi"; then
    icon=""
    ssid=$(nmcli c show --active | grep -v 'bridge' | awk 'BEGIN { FS = "  " } ; /wifi/{ print $1 }')
    status="Connected to ${ssid}"
else
    icon="睊"
    status="offline"
fi

echo "{\"icon\": \"${icon}\", \"status\": \"${status}\"}" 
