free=`which free`
if [ ${free} ]; then
	# memory
	${free} -m | awk 'NR==2{printf "#[bg=colour235,fg=colour76]Mem:%d/%sMB ", $3, $2}'

	ps aux | sed -e "s/\/[^ ]*\///g" | awk '{printf $4 " " $11 "\n"}' | sort -r | awk 'NR==2{printf "#[fg=colour6]Max:%s(%2.1f%%)", $2, $1}'
fi

