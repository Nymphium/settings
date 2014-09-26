IF_FREE=`which free | awk '{printf $2}'`
if [ ! ${IF_FREE} ]; then
	printf "#[bg=colour235]"
	# memory
	free -m | sort -n | \
		awk 'NR==1{
				printf "#[fg=colour76]Mem:"$3"/"
			}NR==2{
				printf $2"MB "
			}'; \

	ps aux | sed -e "s/\/[^ ]*\///g" | awk '{printf $4 " " $11 "\n"}' | \
	sort -r | awk 'NR==2{printf "#[fg=colour6]Max:" $2 "(" $1 "%)＞"}'
fi

IF_VMSTAT=`which vmstat | awk '{printf $2}'`

if [ ! ${IF_VMSTAT} ]; then
	# cpu
	vmstat -w 1 2 | awk 'NR==4{printf "#[fg=colour76]CPU:%d% ", (100 - $15)}'

	top -bn1 | awk 'NR==8{printf "#[fg=yellow]Max:%s(%2.1f%)＞", $12, $9}'
fi

echo "#[fg=colour235]"
