# vim:ft=sh

## oh-my-zsh {{{
ZSH=$HOME/.oh-my-zsh

if [[ -d "${ZSH}" ]]; then
	plugins=(git history zsh_reload)

	if [[ $(uname -s) = 'Darwin' ]]; then
		plugins+=('brew')
		plugins+=('brew-cask')
	fi

	if [[ -e "${ZSH}/plugins/racket" ]]; then
		plugins+=('racket')
	fi

	if command -v sbt > /dev/null 2>&1; then
		plugins+=('sbt')
		plugins+=('scala')
	fi

	if command -v stack > /dev/null 2>&1; then
		plugins+=('stack')
	fi

	if command -v docker > /dev/null 2>&1; then
		plugins+=('docker')
	fi

	if command -v docker-compose > /dev/null 2>&1; then
		plugins+=('docker-compose')
	fi

	export plugins

	DISABLE_AUTO_TITLE=true
	export DISABLE_AUTO_TITLE
	ZSH_THEME="nymphium"
	export ZSH_THEME
	# shellcheck disable=1090
	source "${ZSH}/oh-my-zsh.sh"
fi

autoload -U compinit && compinit -u
## }}}

# shellcheck disable=1036
# shellcheck disable=1088
path=(
	./node_modules/.bin
	${HOME}/bin
	${HOME}/local/bin
	${HOME}/.local/bin
	$path
	/usr/bin/vendor_perl
	/usr/bin/core_perl
	/usr/lib/ccache/bin
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

