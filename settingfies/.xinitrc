#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export XDG_CONFIG_HOME="$HOME/.config"

if [ $DISPLAY ]; then
	xgamma -rgamma 0.8 -bgamma 0.75 -ggamma 0.8

	nitrogen --restore &

	export GTK_IM_MODULE=ibus
	export QT_IM_MODULE=ibus
	export XMODIFIERS=@im=ibus
	ibus-daemon --xim -d

	exec xcompmgr &
	xset r rate 190 20
	exec guake &

	xmodmap /home/beshowjo/.xmodmap
	xbindkeys

	amixer -c 0 set Master mute

	exec openbox-session | xbacklight -set 45%=
else
	setterm -blank 0
fi
