#!/bin/bash

if [ ! $(which xdotool) ]; then
	echo "require xdootool"

	exit 1
fi

function _setwindowsize(){
	xdotool getactivewindow windowsize $@
}

function _setwindowgeometry(){
	xdotool getactivewindow getwindowgeometry windowmove $@
}


while test $# -gt 0; do
	INFO=`xdotool getactivewindow getwindowgeometry`

	CURRENT_SIZE=(`echo ${INFO} | awk '{print $8}' | sed -e "s/x/ /"`)

	CURRENT_POSIT=(`echo ${INFO} | awk '{print $4}' | sed "s/\(-\{0,1\}[0-9]\+\),\(-\{0,1\}[0-9]\+\)/\1 \2/g"`)

	case "$1" in
		-l) # right
			SIZE="`expr ${CURRENT_SIZE[0]} + 80` ${CURRENT_SIZE[1]}" ;;
		-h) # top
			SIZE="`expr ${CURRENT_SIZE[0]} - 80` ${CURRENT_SIZE[1]}" ;;
		-k) # bottom
			SIZE="${CURRENT_SIZE[0]} `expr ${CURRENT_SIZE[1]} + 30`" ;;
		-j)	# left
			SIZE="${CURRENT_SIZE[0]} `expr ${CURRENT_SIZE[1]} - 30`" ;;
		--max|--square)
			MAX=(`xdpyinfo | grep dimensions | awk 'split($2, arr, "x") {print arr[1], arr[2]}'`)

			if [ $1 == "--max" ]; then
				case "$2" in
					--vert)
						SIZE="`expr ${MAX[0]} / 2` ${MAX[1]}"

						case "$3" in
							--left)
								POSIT="0 0" ;;
							--right)
								POSIT="`expr ${MAX[0]} / 2` 0" ;;
							*)
								exit 1 ;;
						esac ;;
					--horiz)
						SIZE="${MAX[0]} ${CURRENT_SIZE[1]}" ;;

					"")
						SIZE="${MAX[0]} ${MAX[1]}"

						POSIT="0 0" ;;
					*)
						exit 1 ;;
				esac
			elif [ $1 == "--square" ]; then
				SIZE="`expr ${MAX[0]} / 2` `expr ${MAX[1]} / 2`"
			fi ;;
		--move)
			SIZE=${CURRENT_SIZE}

			case "$2" in
				-l)
					POSIT="`expr ${CURRENT_POSIT[0]} + 80` ${CURRENT_POSIT[1]}";;
				-h)
					POSIT="`expr ${CURRENT_POSIT[0]} - 80` ${CURRENT_POSIT[1]}";;
				-k)
					POSIT="${CURRENT_POSIT[0]} `expr ${CURRENT_POSIT[1]} - 30`";;
				-j)
					POSIT="${CURRENT_POSIT[0]} `expr ${CURRENT_POSIT[1]} + 30`";;
			esac ;;
	esac

	if [ ! ${POSIT} ]; then
		POSIT=${CURRENT_POSIT}
	fi

	_setwindowgeometry ${POSIT}

	if [ $1 != "--move" ]; then
		_setwindowsize ${SIZE}
	fi

	exit 0
done
