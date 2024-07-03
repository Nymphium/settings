# vim:ft=sh
# shellcheck shell=bash

RCD=$HOME/.zsh.d
if [[ -d "${RCD}" ]] && [[ -n "$(ls -A "${RCD}")" ]] ; then
	for f in "${RCD}"/*; do
		# shellcheck disable=1090
		source "${f}"
	done
fi

ZSH=$HOME/.oh-my-zsh

if [[ ! -d "${ZSH}" ]]; then
	return
fi

plugins=(git history ignore-completions gitignore traildots docker docker-compose direnv golang gopath nix yarn nvm zsh-syntax-highlighting)

if [[ $(uname -s) = 'Darwin' ]]; then
	plugins+=('brew' 'brew-coreutils')
fi

if command -v sbt > /dev/null 2>&1; then
	plugins+=('sbt' 'scala')
fi

if command -v stack > /dev/null 2>&1; then
	plugins+=('stack')
fi

if command -v yarn > /dev/null 2>&1; then
	plugins+=('yarn')
fi


if command -v rbenv >/dev/null 2>&1; then
	plugins+=('rbenv')
fi

export plugins

DISABLE_AUTO_TITLE=true
export DISABLE_AUTO_TITLE
ZSH_THEME="nymphium"
export ZSH_THEME

zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

setopt prompt_subst
setopt magic_equal_subst
setopt hist_ignore_all_dups
setopt hist_verify
setopt hist_expand
setopt hist_ignore_space
setopt no_hup
setopt numeric_glob_sort
setopt auto_param_keys

# shellcheck disable=1091
source "${ZSH}/oh-my-zsh.sh"

# prefer to use local bin
path=(
	"${HOME}"/bin
	"${HOME}"/local/bin
	"${HOME}"/.local/bin
	"${path[@]}"
)

export path
