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
xset r rate 190 20 s off -b -dpms
xmodmap $HOME/.xmodmap
# xbindkeys

xrdb -merge ~/.Xresources

if [[ -e ~/.Xresources.local ]]; then
	xrdb -merge ~/.Xresources.local
fi


exec xcompmgr &

export INIT_AWESOME_LOCK; INIT_AWESOME_LOCK='/tmp/init_awesome.lock'
touch "${INIT_AWESOME_LOCK}"
exec awesome
