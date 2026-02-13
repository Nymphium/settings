if ! (($+commands[opam])); then
  return
fi

source "${HOME}"/.opam/opam-init/init.zsh 1>&2 /dev/null
_evalcache opam config env
