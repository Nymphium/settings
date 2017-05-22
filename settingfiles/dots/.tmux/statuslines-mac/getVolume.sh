MIX="$(osascript -e 'get volume settings')"

if [[ "${#MIX}" -gt 1 ]]; then
	echo "${MIX}" | awk 'BEGIN{col=196}{if(gsub(/true/,"",$8)==0){col=255}gsub(/[^0-9]/,"",$2);printf"#[fg=colour%d]Vol:%d%%＞#[fg=colour27]",col,$2}'
fi
