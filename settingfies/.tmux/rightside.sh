tmux-mem-cpu-load 2 | sed -e "s/ \[.*\]//g" | awk '{print "Mem:"$1,"CPU:"$2}'
