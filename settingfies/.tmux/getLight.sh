# no longer used
xbacklight | awk '{if($1 < 30){printf "◯  "}else if($1 < 70){printf "⛭  "}else{printf "⛯  "}print $1 * 1}'
