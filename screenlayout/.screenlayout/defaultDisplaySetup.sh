#!/bin/sh
xrandr --output DP-0 --off \
	--output DP-1 --off \
	--output HDMI-0 --mode 2560x1440 --pos 0x0 --rotate normal --rate 75 --scale 1x1 \
	--output DP-2 --mode 2560x1440 --pos 2560x0 --rotate normal --rate 165 --scale 1x1 \
	--output DP-3 --off \
	--output DP-4 --mode 2560x1440 --pos 5120x0 --rotate normal --rate 75 --scale 1x1 \
	--output DP-5 --off \
	--output USB-C-0 --off \
	--output None-1-1 --off
