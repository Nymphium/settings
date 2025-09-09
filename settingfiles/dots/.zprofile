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

plugins=(git history gitignore
  traildots
  direnv nix zsh-syntax-highlighting kubectl
  nvim-nest
  brew brew-coreutils
  docker docker-compose
  golang yarn nvm
  gh
  sbt scala stack rbenv)

export plugins

export DISABLE_AUTO_TITLE=true
export ZSH_THEME=nymphium
export ENABLE_CORRECTION="true"

# shellcheck disable=1091
source "${ZSH}/oh-my-zsh.sh"

# : ---

zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

setopt prompt_subst
setopt magic_equal_subst
setopt no_hup
setopt numeric_glob_sort
setopt auto_param_keys

setopt hist_ignore_all_dups
setopt inc_append_history
setopt hist_save_no_dups
unsetopt correct_all
