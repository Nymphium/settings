ps -A -o '%mem comm' | sort --reverse | awk 'BEGIN{max="";usage=0} $1 != "%MEM" && max==""{sub(".*/", "", $2); max=sprintf("#[fg=colour49]Max:%s(%2.1f%%)>", $2, $1)} $1 != "%CPU"{usage+=$1}END{printf "#[bg=colour235,fg=colour6]Mem:%2.1f%% %s", usage, max}'
ps -A -o '%cpu comm' | sort --reverse | awk 'BEGIN{max="";usage=0} $1 != "%CPU" && max==""{sub(".*/", "", $2); max=sprintf("#[fg=colour226]Max:%s(%2.1f%%)>", $2, $1)} $1 != "%CPU"{usage+=$1}END{printf "#[fg=colour118]CPU:%2.1f%% %s#[fg=colour235]", usage, max}'

