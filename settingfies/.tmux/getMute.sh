amixer -c 0 set Headphone 0%- | grep -G on.$ | awk 'END { if(NR > 1){print ""} else {print "#[bg=red]"} }'
