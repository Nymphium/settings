# no longer used
xbacklight | awk '{if($1 < 30){printf "\uff1e"}else if($1 < 70){printf "\uff1e"}else{printf "\uff1e"}print $1 * 1}'
