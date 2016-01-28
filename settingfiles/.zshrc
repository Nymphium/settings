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
# autoload -Uz add-zsh-hook
compinit -u -C

export plugins
plugins=(git history sudo)

if [[ $(uname -s) = 'Darwin' ]]; then
	plugins+='brew'
	plugins+='brew-cask'
fi


export PATH
PATH=${HOME}/bin:${PATH}
PATH+=:${HOME}/local/bin
PATH+=:/usr/bin/vendor_perl:/usr/bin/core_perl
PATH+=:$(ruby -e 'print Gem.user_dir')/bin
PATH+=:/usr/lib/ccache/bin
PATH+=:/opt/java/bin:/opt/java/jre/bin
PATH+=:${HOME}/.luarocks/bin
PATH+=:${HOME}/.cabal/bin

export JAVA_HOME=${JAVA_HOME:-/opt/java}

# LuaRocks path switch each Lua Versions
# function() {
	# local LUA_VERSION
	# LUA_VERSION=$(lua -e 'print(_VERSION)' | awk '{print $2}')

	# export LUA_PATH="${HOME}/.luarocks/share/lua/${LUA_VERSION}/?.lua;${HOME}/.luarocks/share/lua/${LUA_VERSION}/?/init.lua;;"
	# export LUA_CPATH="${HOME}/.luarocks/lib/lua/${LUA_VERSION}/?.so;${HOME}/.luarocks/lib/luarocks/rocks-${LUA_VERSION}/?.so;;"
# }
eval "$(luarocks path)"

if [[ ! "${DISPLAY}" ]]; then
	stty iutf8
fi

# no flow control
stty -ixon

if [[ -d '/usr/local/share/zsh-completions' ]]; then
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
if [[ ! "${TMUX}" ]] && [[ $(which tmux) ]]; then
	function() {
		# if [[ "${SSH_CONNECTION}" ]]; then
			# echo "tmux has been already running. attach?"
			# echo "[a]ttach or [n]ot"
			# read -r tmuxa

			# if [[ "${tmuxa}" = "a" ]]; then
				# tmux attach
			# # else
				# # tmux -2
			# fi
		# else
			local unused
			unused=$(tmux list-sessions | awk '$11!~/.+/{sub(/[^0-9]/,"");print $1;exit}')

			if [[ "${#unused}" -gt 0 ]]; then
				tmux -2 attach -t "${unused}"
			else
				tmux -2
			fi
		# fi
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

