#!/bin/sh

run() {
	if ! pgrep $1 >/dev/null; then
		$@ &
	fi
}

# run streamdeck only if comand exists
if command -v streamdeck >/dev/null 2>&1; then
	run "streamdeck -n"
fi

run "setxkbmap us altgr-intl"
run "/home/$USER/.screenlayout/defaultDisplaySetup.sh"

# if nordvpn is installed, connect to us server
# run "nordvpn c us"

# if greenclip is installed,
run "greenclip daemon"

# if blueman is installed, run blueman-applet
run "blueman-applet"

# ensure firefox is running so faster startup
run "firefox"

# if picom is installed, run picom
run "picom -b"

feh --bg-fill ~/wallpaper.jpg
