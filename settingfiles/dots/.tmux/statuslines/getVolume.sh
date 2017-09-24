MIX=$(amixer -c "${SNDC}" set Master 0%+ | tail -n1 || :)

if [[ "${#MIX}" -gt 1 ]]; then
	echo "${MIX}" | awk 'BEGIN{col=196}{if(gsub(/on/,"",$6)==1){col=255}gsub(/[^0-9]/,"",$4);printf"#[fg=colour%d]Vol:%d%%＞#[fg=colour27]",col,$4}'
fi
