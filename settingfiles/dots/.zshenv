# vim:ft=sh
# shellcheck shell=bash

if [[ -e "${HOME}/.zshenv.local" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.zshenv.local"
fi

# prefer to use local bin
export path=(
	"${HOME}"/bin
	"${HOME}"/local/bin
	"${HOME}"/.local/bin
  "/opt/homebrew/bin"
  "/usr/local/bin"
	"${path[@]}"
)

export EDITOR='nvim'
export MANPAGER="/bin/sh -c \"col -b -x | ${EDITOR} -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
export LANG=${LANG:-en_US.UTF-8}
