# memory
free -m | sort -n | awk 'NR==1{printf "Mem:"$3"/"}NR==2{printf $2"MB => "}'; ps aux | awk '{printf $4 " " $11 "\n"}' | sort -r | awk 'NR==2{printf $2 "(" $1 "%)"}'

# cpu
vmstat -w 1 2 | awk 'NR==4{printf " CPU:%d%", (100 - $15)}'
