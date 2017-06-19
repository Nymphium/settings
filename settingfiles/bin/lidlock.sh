#!/bin/bash

wait_time=3
cmd=i3lock
cmd_args="-e -i /home/nymphium/.config/awesome/lockscreen.png"

if [ ! -n "$(pgrep "${cmd}")" ] && [ ! -e "/tmp/lidnolock" ]; then
	d1=$(date +%s)

	DISPLAY=:0 eval "${cmd} ${cmd_args}"

	while [ -n "$(pgrep "${cmd}")" ]; do
		d2=$(date +%s)

		if [[ ! "$(acpi -b | awk '{print $3}')" =~ "Discharging," ]]; then
			d1=$d2
		fi

		if [ $((d2 - d1)) -gt "${wait_time}" ]; then
			if [ ! -e "/tmp/lidnosuspend" ]; then
				echo "lidnolock.sh: suspend at $(date)" > /dev/kmsg
				systemctl suspend
			fi

			break
		fi

		sleep 1
	done &
fi
