# vim:filetype=sh

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

autoload -Uz compinit promptinit
autoload -Uz promptinit
autoload -Uz add-zsh-hook
compinit -u -C

export plugins
plugins=(git ruby gem history)


export PATH
PATH=${HOME}/bin:${PATH}
PATH+=/usr/bin/vendor_perl:/usr/bin/core_perl:
PATH+=$(ruby -e 'print Gem.user_dir')/bin:
PATH+=/usr/lib/ccache/bin:
PATH+=/opt/java/bin:/opt/java/jre/bin:
PATH+=${HOME}/.luarocks/bin

export JAVA_HOME=${JAVA_HOME:-/opt/java}

# LuaRocks path switch each Lua Versions
function() {
	local LUA_VERSION
	LUA_VERSION=$(lua -e 'print(_VERSION)' | awk '{print $2}')

	export LUA_PATH="${HOME}/.luarocks/share/lua/${LUA_VERSION}/?.lua;;"
	export LUA_CPATH="${HOME}/.luarocks/lib/lua/${LUA_VERSION}/?.so;${HOME}/.luarocks/lib/luarocks/rocks-${LUA_VERSION}/?.so;;"
}

export MANPAGER="/bin/sh -c \"col -b -x|vim -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
export TERM="screen-256color"

if [ ! "${DISPLAY}" ]; then
	stty iutf8
fi

# no flow control
stty -ixon

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

if [[ -d "${HOME}/.oh-my-zsh/plugins/zsh-completions/src" ]]; then
	export fpath
	fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)
fi

if [[ -d "${HOME}/.oh-my-zsh" ]]; then
	source "${ZSH}/oh-my-zsh.sh"

	if [[ -d '/usr/share/zsh/plugins/zsh-syntax-highlighting' ]]; then
		source '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
	fi
fi

# tmux attach
if [[ ! "${TMUX}" ]] && [[ "$(which tmux)" ]]; then
	# if [ "${SSH_CONNECTION}" ]; then
		# tmux -2 kill-session -t "${SSH_CLI_IP}" || :

		# tmux -2 new-session -s "${SSH_CLI_IP}"
	# else
		tmux -2
	# fi
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

