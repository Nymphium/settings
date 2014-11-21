if [ `amixer | awk '{printf $1}'` != "Failed" ]; then
	MUTE=`amixer -c 0 set Master 0%- | grep -G on.$ | \
		awk 'END {
			if(NR > 1){
				print "#[fg=colour255]"
			}else{
				print "#[fg=colour196]"
			}
		}'`

	VOL=`amixer -c 0 set Master 0%- | awk NR==5 | sed -e "s/.*\[\([0-9]*\)%\].*/\1/"`

	echo "${MUTE}Vol:${VOL}#[fg=colour27]"
fi
