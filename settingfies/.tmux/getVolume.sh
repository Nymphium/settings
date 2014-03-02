MUTE=`amixer set Master 0%- | grep -G on.$ | awk 'END { if(NR > 1){print ""} else {print "#[bg=red]"} }'`

VOL=`amixer set Master 0%- | awk 'NR==7' | sed -e "s/.*\[\([0-9]*\)%\].*/\1/"`

echo "${MUTE}Vol:${VOL}"
