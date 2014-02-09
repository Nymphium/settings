#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export XDG_CONFIG_HOME="$HOME/.config"

if [ $DISPLAY ]; then
	nitrogen --restore &

	GTK_IM_MODULE=ibus
	export GTK_IM_MODULE
	QT_IM_MODULE=ibus
	export QT_IM_MODULE
	XMODIFIERS=@im=ibus
	export XMODIFIERS
	ibus-daemon --xim -d

	xcompmgr &
	xset r rate 190 20
	guake &
	xmodmap /home/beshowjo/.xmodmap
	xbindkeys

	exec openbox-session | xbacklight -set 45%= | amixer -c 1 set Headphone 70 | amixer -c 1 set Headphone unmute | amixer -c 1 set Master 87 | amixer -c 1 set PCM 255

else
	setterm -blank 0
fi
