# memory
free -m | sort -n | awk 'NR==1{printf "Mem:"$3"/"}NR==2{printf $2"MB"}'; ps aux | sed -e "s/\/[^ ]*\///g" | awk '{printf $4 " " $11 "\n"}' | sort -r | awk 'NR==2{printf " Max:" $2 "(" $1 "%)"}'

printf "|"

# cpu
vmstat -w 1 2 | awk 'NR==4{printf "CPU:%d% Max:", (100 - $15)}'; ps aux | sed -e "s/\/[^ ]*\///g" | awk '{printf $3 " " $11 "\n"}' | sort -r | awk 'NR==2{printf " Max:" $2 "(" $1 "%)"}'
