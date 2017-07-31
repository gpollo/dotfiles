#!/bin/sh

source ~/.zshrc
xrdb ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinitrc.d/*; do
		[ -f "$F" ] && . "$F"
	done
	unset f
fi

# fix some tiling window manager bugs
wmname LG3D

# start pulse audio
pulseaudio --start

# background picture
feh --bg-fill "Pictures/wallpaper/spacex.png"

# mouse speed/resolution
xset m 1 10
razercfg --res 900

# use french canadian keyboard
setxkbmap ca

# dual monitor setup
xrandr --output HDMI-A-0 --auto --set audio off

# redshift for Montreal city
redshift -l 45.5:-73.6 -t 6500:4000 &

# start xmonad
exec dbus-launch xmonad
