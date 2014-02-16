amixer -c 1 set Master 0%- | grep -G on.$ | awk 'END { if(NR > 1){print ""} else {print "#[bg=red]"} }'
