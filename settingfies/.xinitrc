#!/bin/sh


if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done

	unset f
fi

export XDG_CONFIG_HOME="$HOME/.config"

if [ $DISPLAY ]; then
	amixer -c 0 set Master mute

	export GTK_IM_MODULE=ibus

	export QT_IM_MODULE=ibus

	export XMODIFIERS=@im=ibus

	ibus-daemon --xim -d

	xset r rate 190 20

	exec guake &

	xmodmap $HOME/.xmodmap

	xbindkeys

	xrandr --output LVDS1 --brightness 0.8 --gamma 0.8:0.75:0.7

	nitrogen --restore &

	exec xcompmgr &

	exec openbox-session
else
	setterm -blank 0

	unicode_start
fi
