# vim:ft=sh

## oh-my-zsh {{{
ZSH=$HOME/.oh-my-zsh

if [[ -d "${ZSH}" ]]; then
	export plugins
	plugins=(git history zsh-completions luarocks stack docker)

	if [[ $(uname -s) = 'Darwin' ]]; then
		plugins+=('brew')
		plugins+=('brew-cask')
	fi

	if [[ -e "${ZSH}/plugins/racket" ]]; then
		plugins+=('racket')
	fi

	export DISABLE_AUTO_TITLE=true
	export ZSH_THEME="nymphium"
	# shellcheck disable=1090
	source "${ZSH}/oh-my-zsh.sh"
fi
## }}}

# shellcheck disable=1036
# shellcheck disable=1088
path=(
	${HOME}/bin
	${HOME}/local/bin
	${HOME}/.local/bin(N-/)
	$path
	/usr/bin/vendor_perl
	/usr/bin/core_perl(N-/)
	/usr/lib/ccache/bin(N-/)
)



[[ "$(command -v ruby)" ]] && path+=$(ruby -e 'print Gem.user_dir')/bin

if [[ "$(command -v opam)" ]]; then
	eval "$(opam config env)"
	source ~/.opam/opam-init/init.zsh 1>&2 /dev/null
fi

export JAVA_HOME=${JAVA_HOME:-/opt/java}

if [[ "$(command -v luarocks)" ]]; then
	eval "$(luarocks path --bin)"
fi

## if in interactive shell {{{
if [[ $- == *i* ]]; then
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
	autoload -Uz promptinit
	# autoload -Uz add-zsh-hook
	compinit -u -C

	# no flow control
	stty -ixon

	if [[ ! "${DISPLAY}" ]]; then
		stty iutf8
	fi

	# tmux attach
	if [[ "$(command -v tmux)" ]] && [[ ! "${TMUX}" ]]; then
		() {
			local unused
			unused=$(tmux list-sessions | awk '$11!~/.+/{sub(/[^0-9]/,"");print $1;exit}')

			if [[ ! -z "${unused}" ]]; then
				tmux -u -2 attach -t "${unused}"
			else
				exec tmux -u -2 -l
			fi
		}
	fi

	# keybind
	bindkey '^[e' forward-word
	bindkey '^[w' backward-word
	bindkey -r '^[l'
fi
## }}}

