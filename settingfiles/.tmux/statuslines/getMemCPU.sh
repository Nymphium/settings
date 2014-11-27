free=`which free`
if [ ${free} ]; then
	# memory
	nice -n20 ${free} -m | awk 'NR==2{printf "#[bg=colour235,fg=colour76]Mem:%d/%sMB ", $3, $2}'

	nice -n20 ps aux | sed -e "s/\/[^ ]*\///g" | awk '{printf $4 " " $11 "\n"}' | sort -r | awk 'NR==2{printf "#[fg=colour6]Max:%s(%2.1f%%)＞", $2, $1}'
fi

vmstat=`which vmstat`

if [ ${vmstat} ]; then
	# cpu
	nice -n20 ${vmstat} -w 1 2 | awk 'NR==4{printf "#[fg=colour76]CPU:%d% ", (100 - $15)}'

	cpu_procnum=`nice -n20 awk 'BEGIN{i = 0} $1 == "physical"'{i++}'END{print i}' /proc/cpuinfo`

	line_num=`expr 7 + ${cpu_procnum}`

	nice -n20 top -bn1 -o %CPU | nice -n20 awk NR==${line_num} | awk '{printf "#[fg=colour226]Max:%s(%2.1f%)＞", $11, $7}'
fi

echo "#[fg=colour235]"

