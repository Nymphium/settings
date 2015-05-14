# vim:filetype=sh

ZSH=$HOME/.oh-my-zsh
EDITOR="vim"
DISABLE_AUTO_TITLE=true

ZSH_THEME="nymphium"

export PATH=${HOME}/bin:${PATH}:/usr/bin/vendor_perl:/usr/bin/core_perl:$(ruby -e 'print Gem.user_dir')/bin:/usr/lib/ccache/bin:/usr/lib/colorgcc/bin:/opt/java/bin:/opt/java/jre/bin:${HOME}/.luarocks/bin
# export USE_CCACHE=1
# export CCACHE_PATH="/usr/bin"
# export CCACHE_DIR="/home/beshowjo/.ccache" # use immutable dir
export JAVA_HOME=${JAVA_HOME:-/opt/java}
export LUA_PATH="${HOME}/.luarocks/share/lua/5.2/?.lua;${HOME}/.luarocks/share/lua/5.2/?.so;;"
export LUA_CPATH="${HOME}/.luarocks/lib/lua/5.2/?.so;${HOME}/.luarocks/lib/luarocks/rocks-5.2/?.so;;"
export MANPAGER="/bin/sh -c \"col -b -x|vim -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
export TERM="screen-256color"

plugins=(git ruby gem history nymphium)

if [ ! $DISPLAY ]; then
	stty iutf8
fi

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

if [ -d $HOME/.oh-my-zsh/plugins/zsh-completions/src ]; then
	fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)
fi

if [ -d $HOME/.oh-my-zsh ]; then
	source $ZSH/oh-my-zsh.sh

	if [ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ]; then
		source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
fi

setopt prompt_subst
autoload -Uz add-zsh-hook

# tmux attach
if [ ! $TMUX ] && [ `which tmux` ]; then
	if [ ${SSH_CONNECTION} ]; then
		tmux kill-session -t `echo ${SSH_CLI_IP}`

		tmux -2 new-session -s "${SSH_CLI_IP}"
	else
		tmux -2
	fi
fi


[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

setopt HIST_IGNORE_ALL_DUPS
setopt hist_verify
setopt hist_expand
setopt print_eight_bit
setopt no_flow_control

autoload -Uz compinit
compinit -u -C

# load many dotfiles
function() {
	local _PRV_FILE=$HOME/.privatekeys
	if [ -e ${_PRV_FILE} ] && [ -r ${_PRV_FILE} ]; then
		source ${_PRV_FILE}
	fi
}

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word

