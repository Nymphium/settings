# vim:ft=zsh
# shellcheck shell=zsh

if_have() {
  command -v "${1}" > /dev/null 2>&1
}

# --- Antidote & Interactive Settings ---

# 1. Environment & Helpers needed by plugins
export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

# Initialize completion system early to provide 'compdef' for OMZ plugins
autoload -Uz compinit
compinit -C

# 2. Antidote setup
source "${HOME}/.antidote/antidote.zsh"
antidote load

# Load custom configurations
RCD=$HOME/.zsh.d
if [[ -d "${RCD}" ]] && [[ -n "$(ls -A "${RCD}")" ]]; then
	for f in "${RCD}"/*;
    do
    # shellcheck disable=1090
    source "${f}"
  done
fi

# Styles and Options
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

# --- End Interactive Settings ---

# pipe filter {{{ 
  alias -g G='| grep'
# }}} 

# latex/pdf {{{ 
  alias platex='platex -kanji=utf8 -halt-on-error'
  alias lualatex='lualatex -halt-on-error'
  alias xelatex='xelatex -halt-on-error'
  alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

# git {{{ 
  alias gs='echo you mean `git status` ?'
  alias ghostscript='=gs'
  alias gpo='git push origin'
  alias gpom='git push origin master'
  alias glo='git pull origin'
  alias glom='git pull origin master'
  alias gcom='git checkout master'
# }}} 

alias ps='ps auxfh'
alias ag='ag --hidden -S --stats --ignore=.git'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
alias C='cat'

if_have add_comp_ignores && {
  add_comp_ignores class \
    bcf run.xml
}
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

if_have zoxide && eval "$(zoxide init zsh --cmd cdv)"

unset -f if_have
