#!/bin/bash

ARRAY=(`xdotool getactivewindow getwindowgeometry | awk 'NR==3{print $2}' | sed -e "s/x/ /"`)

function _setwindowsize(){
	xdotool getactivewindow windowsize $@
}

while test $# -gt 0; do
	case "$1" in
		-l|--right)
			SIZE="`expr ${ARRAY[0]} + 80` ${ARRAY[1]}"

			;;
		-h|--left)
			SIZE="`expr ${ARRAY[0]} - 80` ${ARRAY[1]}"

			;;
		-k|--up)
			SIZE="${ARRAY[0]} `expr ${ARRAY[1]} + 30`"

			;;
		-j|--down)
			SIZE="${ARRAY[0]} `expr ${ARRAY[1]} - 30`"

			;;
		*)
			exit 1
			;;
	esac

	_setwindowsize ${SIZE}

	exit 0
done
