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
# }}} 

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

# auto-start zellij for interactive shells
if [[ -o interactive ]] && [[ -z "$ZELLIJ" ]] && command -v zellij >/dev/null 2>&1; then
  _evalcache "zellij setup --generate-completion zsh"

  while true; do
    local session_names
    local session_output
    session_output="$(zellij list-sessions -s 2>/dev/null)"
    if [[ -n "$session_output" ]]; then
      session_names=("${(@f)session_output}")
      # Attach to the first available session
      zellij attach "${session_names[1]}"
    else
      break
    fi
  done

  # If no sessions are left to attach to, start a new one and exit the shell when it's closed
  exec zellij
fi
