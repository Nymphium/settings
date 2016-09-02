# vim:ft=sh

export PATH
PATH=${HOME}/bin:${PATH}
PATH+=:${HOME}/local/bin
PATH+=:${HOME}/.local/bin
PATH+=:/usr/bin/vendor_perl:/usr/bin/core_perl
which ruby >/dev/null 2>&1 &&  PATH+=:$(ruby -e 'print Gem.user_dir')/bin
PATH+=:/usr/lib/ccache/bin
PATH+=:/opt/java/bin:/opt/java/jre/bin
PATH+=:${HOME}/.luarocks/bin
PATH+=:${HOME}/.cabal/bin

export JAVA_HOME=${JAVA_HOME:-/opt/java}

which luarocks >/dev/null 2>&1 && eval "$(luarocks path)"

if [[ ! "${DISPLAY}" ]]; then
	stty iutf8
fi

ZSH=$HOME/.oh-my-zsh
export DISABLE_AUTO_TITLE=true
export ZSH_THEME="nymphium"

zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

setopt prompt_subst
setopt magic_equal_subst
setopt hist_ignore_all_dups
setopt hist_verify
setopt hist_expand
setopt no_hup
setopt numeric_glob_sort
setopt auto_param_keys
unsetopt auto_param_keys

autoload -Uz compinit promptinit
autoload -Uz promptinit
# autoload -Uz add-zsh-hook
compinit -u -C

export plugins
plugins=(git history zsh-completions luarocks stack docker)

if [[ $(uname -s) = 'Darwin' ]]; then
	plugins+=('brew')
	plugins+=('brew-cask')
fi


# no flow control
stty -ixon

if [[ -d "${HOME}/.oh-my-zsh" ]]; then
	source "${ZSH}/oh-my-zsh.sh"
fi

# tmux attach
if [[ ! -z $(which tmux) ]] && [[ ! "${TMUX}" ]]; then
	function() {
		local unused
		unused=$(tmux list-sessions | awk '$11!~/.+/{sub(/[^0-9]/,"");print $1;exit}')

		if [[ ! -z "${unused}" ]]; then
			tmux -2 attach -t "${unused}"
		else
			exec tmux -2
		fi
	}
fi

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word

# load many dotfiles
function() {
	local _PRV_FILE=$HOME/.privatekeys
	if [[ -e "${_PRV_FILE}" ]] && [[ -r "${_PRV_FILE}" ]]; then
		source "${_PRV_FILE}"
	fi
}

