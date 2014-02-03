ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
EDITOR="vim"
# COMPLETION_WAITING_DOTS="true"

export PATH=$PATH:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/beshowjo/.gem/ruby/2.0.0:/home/beshowjo/.gem/ruby/2.0.0/bin:/home/beshowjo/.gem/ruby/2.0.0/doc

plugins=(git)

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

[ -d $HOME/.oh-my-zsh/plugins/zsh-completions/src ] && fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)

source $ZSH/oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Attache tmux
if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && which tmux > /dev/null; then
	if ( tmux has-session ); then
		session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
		if [ -n "$session" ]; then
			echo "Attache tmux session $session."
			tmux attach-session -t $session
		else
			echo "Session has been already attached."
			tmux list-sessions
		fi
	else
		echo "Create new tmux session."
		tmux
	fi
fi

export PS1=\[%{$fg_bold[red]%}%n\ %{$fg_bold[green]%}%p\ %{$fg[cyan]%}%c\ %{$fg_bold[blue]%}%{$fg_bold[blue]%}%\ %{$reset_color%}\]%#\ 

setopt HIST_IGNORE_ALL_DUPS
setopt hist_verify
setopt hist_expand

# load wifi alias
if [ -e ~/.privatekeys ]; then
	source ~/.privatekeys
fi

alias S='sudo'
alias C='cat'
alias V='vim'
alias l='ls -Fal'
alias rmf='sudo rm -rf'
alias chmod='sudo chmod'
alias modc='sudo chmod 755'
alias xterm='xterm -bd black -bg black -cr green -fg green +u8 +ulc +ls zsh'
alias ps='ps aux'
alias day='date +%R && cal'
alias eq='alsamixer -D equal'
alias alsamixer='alsamixer -g'
alias libreoffice='libreoffice --nologo'
alias -g G=' | grepnew'
compdef _grep grepnew

# network
alias wifisearch='sudo killall -r iwlwifi; sudo ip link set wlp6s0 up; sudo iw dev wlp6s0 scan'
alias chrome='google-chrome-stable'
alias pacman='sudo pacman'
alias renew='yaourt -Syua --devel --noconfirm'
alias P='ping 8.8.8.8 -c 3'

# compile
alias platex='platex -kanji=utf8'
alias gcc='gcc -Wall -lm -std=c99 -O3'
alias gpp='g++'

# other
alias englize='export LANG=en_US.UTF-8'
alias japanize='export LANG=ja_JP.UTF-8'
alias lmap='xmodmap $HOME/.xmodmap'

# tmux config
alias tmuxn='tmux source-file ~/.tmux.conf'
alias tmuxd='tmux detach'
alias tmuxa='tmux attach'

