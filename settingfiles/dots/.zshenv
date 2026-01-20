# vim:ft=sh
# shellcheck shell=bash

# prefer to use local bin
export path=(
	"${HOME}"/bin
	"${HOME}"/local/bin
	"${HOME}"/.local/bin
  "/opt/homebrew/bin"
  "/usr/local/bin"
	"${path[@]}"
)

export LANG=en_US.UTF-8
export HISTSIZE=10000000
export SAVEHIST=10000000

if [[ -e "${HOME}/.zshenv.local" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.zshenv.local"
fi
