# vim:ft=zsh

[[ -n "$ZPROF" ]] && zmodload zsh/zprof

export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

autoload -Uz compinit && compinit -C

source "${HOME}/.antidote/antidote.zsh"
antidote load

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history hist_ignore_all_dups hist_reduce_blanks extended_history

# options
setopt prompt_subst magic_equal_subst no_hup numeric_glob_sort auto_param_keys auto_cd auto_pushd pushd_ignore_dups
unsetopt correct_all

# completion style
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1
# override zephyr's completer: _approximate is extremely slow with many commands in PATH
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' rehash false

# tools (evalcache loaded via antidote)
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# keybinds
stty -ixon
[[ ! "${DISPLAY}" ]] && stty iutf8
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
WORDCHARS=''
bindkey '^[d' kill-word
bindkey '^[e' forward-word
bindkey '^[w' backward-word
bindkey -r '^[l'

# traildots inline (.. and ... only)
alias ..='cd ../'
alias ...='cd ../../'

# directory stack shortcuts
alias d='dirs -v | head -20'
for i ({1..9}) alias "$i=builtin cd -$((i-1))"; unset i

alias l='ls -Fhal --color=auto'

[[ -n "$ZPROF" ]] && zprof
