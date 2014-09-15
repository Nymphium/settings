# vim:filetype=sh

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
EDITOR="vim"
DISABLE_AUTO_TITLE=true
# COMPLETION_WAITING_DOTS="true"

export PATH=$PATH:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/beshowjo/.gem/ruby/2.1.0:/usr/lib/ccache/bin:/usr/lib/colorgcc/bin:/opt/java/bin:/opt/java/jre/bin
# RUBYGEM=/home/beshowjo/.gem/ruby/2.1.0
# export PATH=$PATH:$RUBYGEM/bin:$RUBYGEM/doc:$RUBYGEM/gems

export USE_CCACHE=1
export CCACHE_PATH="/usr/bin"
export CCACHE_DIR="/home/beshowjo/.ccache"

export JAVA_HOME=${JAVA_HOME:-/opt/java}

plugins=(git ruby gem history)

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

if [ -d $HOME/.oh-my-zsh/plugins/zsh-completions/src ]; then
	fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)
fi

export TERM="screen-256color"

# if tmux has-session; then
	# tmux attach
if [ ! $TMUX ]; then
	tmux -2
fi 

if [ -d $HOME/.oh-my-zsh ]; then
	source $ZSH/oh-my-zsh.sh
	source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ ${SSH_CONNECTION} ]; then
	# SSH="%{$fg[green]%}from %{$fg[blue]%}`echo ${SSH_CONNECTION} | awk '{print $1}'`"
	SSH="%{$fg[green]%}over%{$fg[blue]%}SSH"
fi

export PS1=\[%{$fg_bold[red]%}%n\ ${SSH}%{$fg_bold[green]%}%p\ %{$fg[cyan]%}%c\ %{$fg_bold[blue]%}%{$fg_bold[blue]%}%\ %{$reset_color%}\]%#\ 

# if [ -d $HOME/.vim/bundle/vimpager/vimpager ]; then
	# export PAGER=$HOME/.vim/bundle/vimpager/vimpager
# fi

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

setopt HIST_IGNORE_ALL_DUPS
setopt hist_verify
setopt hist_expand
setopt print_eight_bit
setopt no_flow_control

autoload -Uz compinit
compinit -uC

# load many dotfiles
_PRV_FILE=$HOME/.privatekeys
if [ -e ${_PRV_FILE} ] && [ -r ${_PRV_FILE} ]; then
	source ${_PRV_FILE}
fi
unset _PRV_FILE

# aliases
alias S='sudo'
alias C='cat'
alias V='vim'
alias reboot='systemctl reboot -i'
alias poweroff='systemctl poweroff -i'
alias shutdown='sudo poweroff'
alias rmf='sudo rm -rf'
alias cpr='cp -r'
alias chmod='sudo chmod'
alias modc='sudo chmod 755'
alias ps='ps auxfh'
alias day='date +%R && cal'
alias libreoffice='libreoffice --nologo'
alias -g G=' | grep -iE'
alias visudo='sudo VISUAL=vim visudo'
alias suspend='sudo systemctl suspend'
alias eq='alsamixer -D equal'
alias alsamixer='alsamixer -gc 0'
alias ag='ag --hidden -S --stats'
alias ....='cd ../../../..'
alias dmesg='dmesg -TL'
alias less='vim -R'

#suffix
alias -s rb=ruby
alias -s {png,jpg,PNG,JPG,JPEG}=gimmage
alias -s {mp3,mp4}=vlc
alias -s pdf=evince

## network
alias wifisearch='sudo iw dev wlp6s0 scan'
alias pacman='sudo pacman'
alias pacs='sudo pacman -S --noconfirm'
alias yaous='yaourt -S --noconfirm'
alias pkgsearch='yaourt -Ss'
alias renew='gem update 2>&1 /dev/null & sudo pacman -Sc --noconfirm && yaourt -Syua --devel --noconfirm && sudo pacman-optimize && sudo updatedb &'
alias P='ping 8.8.8.8 -c 3'

## compile, interp
alias platex='platex -kanji=utf8'
alias gcc='gcc -Wall -lm -std=c99 -O3 -march=core-avx-i'
alias gpp='g++'
alias R='ruby'
alias mkernel='make -j4 CC="ccache gcc" CXX="ccache g++"'

## other
alias englize='export LANG=en_US.UTF-8'
alias japanize='export LANG=ja_JP.UTF-8'
alias lmap='xmodmap $HOME/.xmodmap'

## tmux config
alias tmuxn='tmux -2 source-file $HOME/.tmux.conf'
alias tmuxd='tmux detach'
alias tmuxa='tmux -2 attach'

