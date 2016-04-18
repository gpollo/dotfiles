#!/bin/sh

source ~/.zshrc
xrdb ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinitrc.d/*; do
		[ -f "$F" ] && . "$F"
	done
	unset f
fi

wmname LG3D

while true; do
	xsetroot -name "$(dwm-status | sed "s/&/&amp;/g")"
	sleep 1
done &

xset m 1 10
pulseaudio --start
feh --bg-fill Pictures/wallpaper/laser.jpg

for APP in $APP_START; do
	$APP&
done

exec dbus-launch dwm
