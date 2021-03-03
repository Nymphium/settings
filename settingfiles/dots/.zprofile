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

	if command -v docker-compose > /dev/null 2>&1; then
		plugins+=('github')
	fi

	if command -v yarn > /dev/null 2>&1; then
		plugins+=('yarn')
	fi

	export plugins

	DISABLE_AUTO_TITLE=true
	export DISABLE_AUTO_TITLE
	ZSH_THEME="nymphium"
	export ZSH_THEME
	# shellcheck disable=1090
	source "${ZSH}/oh-my-zsh.sh"

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

	autoload -Uz compinit promptinit add-zsh-hook
	compinit -u -C
fi
## }}}

# shellcheck disable=1036
# shellcheck disable=1088
path=(
	${HOME}/bin
	${HOME}/local/bin
	${HOME}/.local/bin
	$path
)
