#!/bin/bash
CONN=$(xrandr -q | grep HDMI2 | cut -f 2 -d " ")
if [ "$CONN" == "connected" ]; then
    xrandr --output HDMI2 --primary --preferred --output LVDS1 --auto --right-of HDMI2
    #xrandr --output LVDS1 --auto --output HDMI2 --auto --same-as LVDS1 
    ~/.spectrwm/start.sh br0
else
    xrandr --output HDMI2 --off
    ~/.spectrwm/start.sh wlan0
fi
