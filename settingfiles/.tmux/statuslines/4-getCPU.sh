vmstat=`which vmstat`

if [ ${vmstat} ]; then
	# cpu
	${vmstat} -w 1 2 | awk 'NR==4{printf "#[fg=colour76]CPU:%d% ", (100 - $15)}'

	cpu_procnum=`awk 'BEGIN{i = 0} $1 == "physical"'{i++}'END{print i}' /proc/cpuinfo`

	line_num=`expr 7 + ${cpu_procnum}`

	top -bn1 -o %CPU | awk NR==${line_num} | awk '{printf "#[fg=colour226]Max:%s(%2.1f%)", $11, $7}'
fi

echo "#[fg=colour235]"

