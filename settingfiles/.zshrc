# vim:filetype=sh

ZSH=$HOME/.oh-my-zsh
EDITOR="vim"
DISABLE_AUTO_TITLE=true

export PATH=$PATH:${HOME}/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:${HOME}/.gem/ruby/2.1.0:${HOME}/.gem/ruby/2.1.0/bin:/usr/lib/ccache/bin:/usr/lib/colorgcc/bin:/opt/java/bin:/opt/java/jre/bin

export USE_CCACHE=1
export CCACHE_PATH="/usr/bin"
export CCACHE_DIR="/home/beshowjo/.ccache" # use immutable dir

export JAVA_HOME=${JAVA_HOME:-/opt/java}

export LUA_PATH="${HOME}/.luarocks/share/lua/5.2/?.lua;${HOME}/.luarocks/share/lua/5.2/?.so;;"
export LUA_CPATH="${HOME}/.luarocks/lib/lua/5.2/?.so;${HOME}/.luarocks/lib/luarocks/rocks-5.2/?.so;;"

export MANPAGER="/bin/sh -c \"col -b -x|vim -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""

export TERM="screen-256color"

plugins=(git ruby gem history)

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

# prompt theme
if [ $UID -eq 0 ]; then
	colors=("red" "magenta")

	rootprm="#"
else
	colors=("green" "blue")

	rootprm="="
fi

if [ ${SSH_CONNECTION} ]; then
	SSH="[over %{$fg[${colors[2]}]%}SSH%{$fg[${colors[1]}]%}] "

	SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
fi

export PROMPT='%{$fg_bold[${colors[1]}]%}>> ${SSH}%p%{$fg[cyan]%}%c%{$reset_color%}$(git_prompt_info)%{$fg_bold[${colors[2]}]%} ${rootprm}>>%{$reset_color%} '

# display branch at that current repo to prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}::%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

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

autoload -U -z compinit
compinit -u -C

# load many dotfiles
_PRV_FILE=$HOME/.privatekeys
if [ -e ${_PRV_FILE} ] && [ -r ${_PRV_FILE} ]; then
	source ${_PRV_FILE}
fi
# unset _PRV_FILE

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word

