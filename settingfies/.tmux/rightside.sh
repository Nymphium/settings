free -m | sort -n | awk 'NR==1{printf $3"/"}NR==2{printf $2"MB"}';vmstat -w 1 2 | awk 'NR==4{printf " %d%", (100 - $15)}'
