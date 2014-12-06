
#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinitrc.d/*; do
		[ -f "$F" ] && . "$F"
	done
	unset f
fi

export STEAM_RUNTIME=0
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
wmname LG3D

while true; do
	xsetroot -name "$(date +%H:%M:%S)"
done &

xset m 1 10
compton -b -cCGfF -o 0.38 -O 200 -I 200 -t 0 -l 0 -r 3 -D2 -m 0.88
pulseaudio --start
feh --bg-fill /home/gabriel/Pictures/wallpaper/LHC.png

transmission-gtk&
thunderbird&
hexchat&
steam&
firefox-gtk3&

exec dbus-launch dwm
