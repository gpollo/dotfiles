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
	xsetroot -name "$(dwm-status)"
	sleep 1
done &

xset -b
xset m 1 10
compton -b -cCGfF -o 0.60 -O 200 -I 200 -t 0 -l 0 -r 3 -D2 -m 0.88
pulseaudio --start
feh --bg-fill /home/gabriel/Pictures/wallpaper/nuclear.jpg

for APP in $APP_START; do
	$APP&
done

exec dbus-launch dwm
