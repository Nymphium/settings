# vim:ft=zsh

[[ -n "$ZPROF" ]] && zmodload zsh/zprof

export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

source "${HOME}/.antidote/antidote.zsh"
# compinit must see zsh-completions, yet run before plugins that call compdef
() { local d; d=$(antidote path zsh-users/zsh-completions 2>/dev/null) && fpath=("$d/src" $fpath) }
autoload -Uz compinit && compinit
antidote load

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history hist_ignore_all_dups hist_reduce_blanks extended_history

# options
setopt magic_equal_subst no_hup numeric_glob_sort auto_param_keys auto_cd auto_pushd pushd_ignore_dups
# macOS's stock /etc/zshrc sets this but nix-darwin's doesn't; without it ZLE prints U+FE0F as <fe0f>
setopt combining_chars

# completion style
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _complete _match

# tools (evalcache loaded via antidote)
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# keybinds
stty -ixon
[[ ! "${DISPLAY}" ]] && stty iutf8
zmodload zsh/terminfo
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char
bindkey '^[[3~' delete-char
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
bindkey '^[[Z' reverse-menu-complete

# traildots inline (.. and ... only)
alias ..='cd ../'
alias ...='cd ../../'

# directory stack shortcuts
alias d='dirs -v | head -20'
for i ({1..9}) alias "$i=builtin cd +$i"; unset i

alias l='ls -Fhal --color=auto'

# Cursor CLI keeps MCP approvals per directory, so it would ask again in every new one
alias agent='agent --approve-mcps'
alias cursor-agent='cursor-agent --approve-mcps'

[[ -n "$ZPROF" ]] && zprof
