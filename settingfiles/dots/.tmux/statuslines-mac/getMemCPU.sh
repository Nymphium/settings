ps -A -o '%mem comm' | sort --reverse | awk 'BEGIN{max="";usage=0} $1 != "%MEM" && max==""{sub(".*/", "", $2); max=sprintf("|Max:%s(%2.1f%%) ", $2, $1)} $1 != "%CPU"{usage+=$1}END{printf "#[bg=colour6] #[fg=colour253]Mem:%2.1f%%%s#[fg=colour29]", usage, max}'
ps -A -o '%cpu comm' | sort --reverse | awk 'BEGIN{max="";usage=0} $1 != "%CPU" && max==""{sub(".*/", "", $2); max=sprintf("|Max:%s(%2.1f%%) ", $2, $1)} $1 != "%CPU"{usage+=$1}END{printf "#[bg=colour106] #[fg=colour253]CPU:%2.1f%%%s#[fg=colour064]", usage, max}'

