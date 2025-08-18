#!/bin/sh

xrandr --output DisplayPort-0 --mode 800x600 --rate 60
sleep 2
xrandr --output DisplayPort-0 --mode 2560x1440 --rate 165
sleep 1
echo 'awesome.restart()' | awesome-client
