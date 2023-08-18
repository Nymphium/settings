# vim:ft=sh
# shellcheck shell=bash

path=(
	"${HOME}"/bin
	"${HOME}"/local/bin
	"${HOME}"/.local/bin
	"${path[@]}"
)

export path

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

plugins=(git history ignore-completions gitignore traildots)

if [[ $(uname -s) = 'Darwin' ]]; then
	plugins+=('brew' 'brew-coreutils')
fi

if command -v sbt > /dev/null 2>&1; then
	plugins+=('sbt')
	plugins+=('scala')
fi

if command -v stack > /dev/null 2>&1; then
	plugins+=('stack')
fi

if command -v docker > /dev/null 2>&1; then
	plugins+=('docker')
fi

if command -v docker-compose > /dev/null 2>&1; then
	plugins+=('docker-compose')
fi

if command -v gh > /dev/null 2>&1; then
	plugins+=('github')
fi

if command -v yarn > /dev/null 2>&1; then
	plugins+=('yarn')
fi

if command -v direnv >/dev/null 2>&1; then
	plugins+=('direnv')
fi

if command -v go >/dev/null 2>&1; then
	plugins+=('golang' 'gopath')
fi

if command -v nix >/dev/null 2>&1; then
	plugins+=('nix')
fi

if command -v opam >/dev/null 2>&1; then
	plugins+=('opam')
fi

plugins+=(yarn nvm tmux)

export plugins

DISABLE_AUTO_TITLE=true
export DISABLE_AUTO_TITLE
ZSH_THEME="nymphium"
export ZSH_THEME

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_UNICODE=true
ZSH_TMUX_FIXTERM_WITH_256COLOR=tmux-256color
export \
	ZSH_TMUX_AUTOSTART \
	ZSH_TMUX_UNICODE \
	ZSH_TMUX_FIXTERM_WITH_256COLOR

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

autoload -Uz compinit promptinit
compinit -u -C

# shellcheck disable=1091
source "${ZSH}/oh-my-zsh.sh"
