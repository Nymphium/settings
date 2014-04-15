ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
EDITOR="vim"
DISABLE_AUTO_TITLE=true
# COMPLETION_WAITING_DOTS="true"

export PATH=$PATH:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/beshowjo/.gem/ruby/2.1.0:/home/beshowjo/.gem/ruby/2.1.0/bin:/home/beshowjo/.gem/ruby/2.1.0/doc:/home/beshowjo/works/ruby:/usr/lib/ccache/bin

plugins=(git)

if [[ -d /usr/local/share/zsh-completions ]]; then
	fpath=($fpath /usr/local/share/zsh-completions)
fi

[ -d $HOME/.oh-my-zsh/plugins/zsh-completions/src ] && fpath=($HOME/.oh-my-zsh/plugins/zsh-completions/src $fpath)

source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Attache tmux
if [ -z "$TMUX" ] && [ $#DISPLAY -gt 0 ]; then
	tmux
fi

export PS1=\[%{$fg_bold[red]%}%n\ %{$fg_bold[green]%}%p\ %{$fg[cyan]%}%c\ %{$fg_bold[blue]%}%{$fg_bold[blue]%}%\ %{$reset_color%}\]%#\ 

setopt HIST_IGNORE_ALL_DUPS
setopt hist_verify
setopt hist_expand

autoload -U compinit
compinit -u

# zstyle ':completion:*' verbose yes
# zstyle ':completion:*' format '%B%d%b'
# zstyle ':completion:*:warnings' format 'No matches for: %d'
# zstyle ':completion:*' group-name ''

# load many dotfiles
_PRV_FILE=$HOME/.privatekeys
if [ -e $_PRV_FILE ] && [ -r $_PRV_FILE ]; then
	source $_PRV_FILE
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
alias xterm='xterm -bd black -bg black -cr green -fg green +u8 +ulc +ls zsh'
alias ps='ps aux'
alias day='date +%R && cal'
alias libreoffice='libreoffice --nologo'
alias -g G=' | grep -iE'
alias visudo='sudo VISUAL=vim visudo'
alias suspend='sudo systemctl suspend'
alias eq='alsamixer -D equal'
alias alsamixer='alsamixer -gc 0'
alias ag='ag --hidden -S --stats'

## network
alias wifisearch='sudo killall -r iwlwifi; sudo ip link set wlp6s0 up; sudo iw dev wlp6s0 scan'
alias chrome='google-chrome-stable'
alias pacman='sudo pacman'
alias pacs='sudo pacman -S --noconfirm'
alias yaous='yaourt -S --noconfirm'
alias pkgsearch='yaourt -Ss'
alias renew='sudo pacman -Sc --noconfirm && sudo yaourt -Syua --devel --noconfirm && sudo pacman-optimize; sudo updatedb'
alias P='ping 8.8.8.8 -c 3'

## compile
alias platex='platex -kanji=utf8'
alias gcc='gcc -Wall -lm -std=c99 -O3 -march=core-avx-i'
alias gpp='g++'
alias R='ruby'

## other
alias englize='export LANG=en_US.UTF-8'
alias japanize='export LANG=ja_JP.UTF-8'
alias lmap='xmodmap $HOME/.xmodmap'

## tmux config
alias tmuxn='tmux source-file $HOME/.tmux.conf'
alias tmuxd='tmux detach'
alias tmuxa='tmux attach'
