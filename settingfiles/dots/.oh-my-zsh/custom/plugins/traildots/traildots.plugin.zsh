for ((i = 1; i < 11; i++));  (){
  local name;name=$(printf "."%.0s {1..${i}})
  local cmd;cmd="cd ./$(printf "../"%.0s {1..${i}})"
  alias .${name}=${cmd}
  alias .${name}l="${cmd} && l"
}
