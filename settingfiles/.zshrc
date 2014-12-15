# vim:filetype=sh

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
EDITOR="vim"
DISABLE_AUTO_TITLE=true

export PATH=$PATH:${HOME}/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:${HOME}/.gem/ruby/2.1.0:${HOME}/.gem/ruby/2.1.0/bin:/usr/lib/ccache/bin:/usr/lib/colorgcc/bin:/opt/java/bin:/opt/java/jre/bin

export USE_CCACHE=1
export CCACHE_PATH="/usr/bin"
export CCACHE_DIR="/home/beshowjo/.ccache"

export JAVA_HOME=${JAVA_HOME:-/opt/java}

export LUA_PATH="${HOME}/.luarocks/share/lua/5.2/?.lua;;"
export LUA_CPATH="${HOME}/.luarocks/lib/lua/5.2/?.so;${HOME}/.luarocks/lib/luarocks/rocks-5.2/?.so;;"

export MANPAGER="/bin/sh -c \"col -b -x|vim -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""

plugins=(git ruby gem history)

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

if [ -d $HOME/.oh-my-zsh/plugins/zsh-completions/src ]; then
	fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)
fi

export TERM="screen-256color"

if [ -d $HOME/.oh-my-zsh ]; then
	source $ZSH/oh-my-zsh.sh

	if [ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ]; then
		source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
fi

if [ ${SSH_CONNECTION} ]; then
	SSH="%{$fg[green]%}over %{$fg[blue]%}SSH"

	SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
fi

export PS1=\[%{$fg_bold[red]%}%n\ ${SSH}%{$fg_bold[green]%}%p\ %{$fg[cyan]%}%c\ %{$fg_bold[blue]%}%{$fg_bold[blue]%}%\ %{$reset_color%}\]%#\ 

unset SSH

# tmux attach
if [ ! $TMUX ]; then
	if [ ${SSH_CONNECTION} ]; then
		tmux kill-session -t `echo ${SSH_CLI_IP}`

		nice -n0 tmux -2 new-session -s "${SSH_CLI_IP}"
	else
		nice -n0 tmux -2
	fi

fi

unset SSH_CLI_IP

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

setopt HIST_IGNORE_ALL_DUPS
setopt hist_verify
setopt hist_expand
setopt print_eight_bit
setopt no_flow_control

autoload -U -z compinit
compinit -u -C

# load many dotfiles
_PRV_FILE=$HOME/.privatekeys
if [ -e ${_PRV_FILE} ] && [ -r ${_PRV_FILE} ]; then
	source ${_PRV_FILE}
fi
unset _PRV_FILE

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word

