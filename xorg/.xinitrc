#!/bin/sh

source ~/.zshrc

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinitrc.d/*; do
		[ -f "$F" ] && . "$F"
	done
	unset f
fi

# TODO check if commands exist

# fix some tiling window manager bugs
wmname LG3D

# start pulse audio
pulseaudio --start

# mouse speed/resolution
xset m 1 0
razercfg --res 900

# use french canadian keyboard
setxkbmap ca

# monitor setup
if xrandr | grep LVDS-1; then
    xrandr --output "LVDS-1" --mode "1920x1080" --primary
else
    xrandr --output "HDMI-A-1"      --mode "1920x1080" --left-of  "HDMI-A-0"
    xrandr --output "DisplayPort-1" --mode "1920x1080" --right-of "HDMI-A-0"
    xrandr --output "HDMI-A-0"      --mode "1920x1080" --primary
fi

# disable mouse acceleration
xset m 1 0

# redshift for Montreal city
redshift -l 45.5:-73.6 -t 6500:4000 &

# compton compositor
compton&

# background picture
feh --bg-fill "$HOME/Pictures/wallpaper/material3.png"

# start xmonad
exec dbus-launch i3
