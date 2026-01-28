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

# 3. Load Theme
eval "$(starship init zsh)"
export STARSHIP_CACHE=~/.starship/cache
mkdir -p "$STARSHIP_CACHE"

# Dynamic Theme Switching (macOS)
if [[ "$(uname)" == "Darwin" ]]; then
  _update_starship_theme() {
    local mode
    local current_mode_file="${STARSHIP_CACHE}/mode"
    local effective_config="${STARSHIP_CACHE}/effective.toml"

    # Detect Mode
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      mode="dark_mode"
    else
      mode="light_mode"
    fi

    # Only regenerate if mode changed or config missing
    if [[ ! -f "$effective_config" ]] || [[ "$mode" != "$(cat "$current_mode_file" 2>/dev/null)" ]]; then
      # Ensure config exists before trying to read it
      if [[ -f "${HOME}/.config/starship.toml" ]]; then
        echo "palette = \"$mode\"" > "$effective_config"
        cat "${HOME}/.config/starship.toml" >> "$effective_config"
        echo "$mode" > "$current_mode_file"
      fi
    fi
    
    export STARSHIP_CONFIG="$effective_config"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _update_starship_theme
fi

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

if ls --color -d / >/dev/null 2>/dev/null; then
  # ls is GNU ls
  alias ls='ls --color'
elif ls -G -d / >/dev/null 2>/dev/null; then
  # ls has a -G option, assume it means to display colors like on FreeBSD
  alias ls='ls -G'
fi

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

eval "$(zoxide init zsh --cmd cdv)"

unset -f if_have
