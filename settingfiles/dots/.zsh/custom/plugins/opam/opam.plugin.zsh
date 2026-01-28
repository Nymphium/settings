if [[ ! $(command -v opam > /dev/null 2>&1) ]]; then
  return
fi

source "${HOME}"/.opam/opam-init/init.zsh 1>&2 /dev/null
eval "$(opam config env)"
