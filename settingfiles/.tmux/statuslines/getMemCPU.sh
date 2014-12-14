free=`which free`
if [ ${free} ]; then
	# memory
	${free} -m | awk 'BEGIN{{total = 0}{used = 0}} {{total += $2}{used += $3}} END{printf "#[bg=colour235,fg=colour76]Mem:%d/%sMB ", used, total}'

	ps -axho comm,%mem --sort -%mem | awk 'NR==1{printf "#[fg=colour6]Max:%s(%2.1f%%)＞", $1, $2}'
fi


vmstat=`which vmstat`

if [ ${vmstat} ]; then
	# cpu
	vmstat -w 1 2 | awk 'NR==4{printf "#[fg=colour76]CPU:%d% ", (100 - $15)}'

	top -bn1 -o %CPU | awk 'BEGIN{d1 = ""}{if(d1 == "PID"){exit} d1 = $1} END{printf "#[fg=colour226]Max:%s(%2.1f%%)＞", $11, $7}'
fi

echo "#[fg=colour235]"

