#!/bin/sh


if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done

	unset f
fi

export XDG_CONFIG_HOME="$HOME/.config"

export GTK_IM_MODULE=ibus

export QT_IM_MODULE=ibus

export XMODIFIERS=@im=ibus

ibus-daemon --xim -d

xset r rate 190 20

xmodmap $HOME/.xmodmap

xbindkeys


exec xcompmgr &

exec tilda &

hsetroot -solid "#000000" && nitrogen --restore &

exec openbox-session

