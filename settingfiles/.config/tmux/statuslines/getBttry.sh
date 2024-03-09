#!/bin/env zsh

batmax=0
batnow=0

for bat in /sys/class/power_supply/BAT[0-9]; do
	batmax=$(("${batmax}" + 100))
	batnow=$(("${batnow}" + "$(cat "${bat}"/capacity)"))
done

batnow=$(("${batnow}" * 100 / "${batmax}"))

bg=""
fg=202

charged=""
if [ "$(cat /sys/class/power_supply/AC/online)" = 1 ]; then
	charged="Charged "
fi

if [ "${batnow}" -lt 10 ]; then
	bg="#[bg=colour196]"
	fg=255
elif [ "${batnow}" -lt 20 ]; then
	bg="#[bg=colour226]"
fi

printf "%s#[fg=colour%d]Bat:%s%s%%＞" "${bg}" "${fg}" "${charged}" "${batnow}"

