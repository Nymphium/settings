#!/bin/bash

CURRENT_SIZE=(`xdotool getactivewindow getwindowgeometry | awk 'NR==3{print $2}' | sed -e "s/x/ /"`)

function _setwindowsize(){
	xdotool getactivewindow windowsize $@
}

function _setwindowgeometry(){
	xdotool getactivewindow getwindowgeometry windowmove $@ > /dev/null
}

while test $# -gt 0; do
	case "$1" in
		-l|--right)
			SIZE="`expr ${CURRENT_SIZE[0]} + 80` ${CURRENT_SIZE[1]}" ;;
		-h|--left)
			SIZE="`expr ${CURRENT_SIZE[0]} - 80` ${CURRENT_SIZE[1]}" ;;
		-k|--up)
			SIZE="${CURRENT_SIZE[0]} `expr ${CURRENT_SIZE[1]} + 30`" ;;
		-j|--down)
			SIZE="${CURRENT_SIZE[0]} `expr ${CURRENT_SIZE[1]} - 30`" ;; 
		--max|--square)
			MAX=(`xdpyinfo | grep dimensions | awk 'split($2, arr, "x") {print arr[1], arr[2]}'`)

			if [ $1 == "--max" ]; then
				case "$2" in
					--vert)
						SIZE="`expr ${MAX[0]} / 2` ${MAX[1]}"

						case "$3" in
							--left)
								GEOM="0 0";;

							--right)
								GEOM="`expr ${MAX[0]} / 2` 0"
						esac ;;
					--horiz)
						SIZE="${MAX[0]} `expr ${MAX[1]} / 2`";;
					*)
						SIZE="${MAX[0]} ${MAX[1]}"

						GEOM="0 0";;
				esac

				_setwindowgeometry ${GEOM}
			elif [ $1 == "--square" ]; then
				SIZE="`expr ${MAX[0]} / 2` `expr ${MAX[1]} / 2`"
			fi ;;
		*)
			exit 1 ;;
	esac

	_setwindowsize ${SIZE}

	exit 0
done
