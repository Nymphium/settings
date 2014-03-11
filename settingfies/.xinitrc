#!/bin/sh

_vol(){
	for i in $@; do
		amixer -c 0 set $i 100%= > /dev/null
	done
	unset i

	amixer -c 0 set Master mute
}


if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export XDG_CONFIG_HOME="$HOME/.config"

if [ $DISPLAY ]; then
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

	exec openbox-session | xbacklight -set 45%= | _vol Master Headphone Speaker && unset _vol 
else
	setterm -blank 0
fi
