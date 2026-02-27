# vim:ft=zsh
# shellcheck shell=zsh

[[ -n "$ZPROF" ]] && zmodload zsh/zprof

# --- Antidote & Interactive Settings ---

# 1. Environment & Helpers needed by plugins
export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

# Initialize completion system early to provide 'compdef' for OMZ plugins
autoload -Uz compinit && compinit -C

# 2. Antidote setup
source "${HOME}/.antidote/antidote.zsh"
antidote load

# Styles and Options
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

setopt prompt_subst
setopt magic_equal_subst
setopt no_hup
setopt numeric_glob_sort
setopt auto_param_keys

unsetopt correct_all

# --- End Interactive Settings ---

# pipe filter {{{ 
  alias -g G='| grep'
# }}} 

alias C='cat'

# interactive shell settings {{{ 
# no flow control
stty -ixon

if [[ ! "${DISPLAY}" ]]; then
  stty iutf8
fi

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word
bindkey -r '^[l'
# }}} 

[[ -n "$ZPROF" ]] && zprof
