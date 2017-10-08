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

