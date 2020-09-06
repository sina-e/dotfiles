#!/bin/bash

VOL=$(amixer -M get Master | awk -F"[][]" '/%/ { print $2 }' | awk -F"%" 'BEGIN{tot=0; i=0} {i++; tot+=$1} END{printf("%s\n", tot/i) }')

ICON=/usr/share/icons/Moka/16x16/devices/audio-card.png

pkill xfce4-notifyd

notify-send -t 3000 -- "Volume" "$VOL"
