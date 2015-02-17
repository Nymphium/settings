# vim: ft=sh

# newst `grep` deprecate GREP_OPTIONS shell variable, but oh-my-zsh still defines GREP_OPTIONS
unset GREP_OPTIONS
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'


alias S='sudo'
alias C='cat'
alias V='vim'
alias rmf='sudo rm -rf'
alias cpr='cp -r'
alias modc='sudo chmod 755'
alias day='date +%R && cal'
alias -g G=' | grep -iE'
alias visudo='sudo VISUAL=vim visudo'
alias suspend='sudo systemctl suspend'
alias ....='cd ../../../..'
alias wpa_reconf='killall -1 wpa_supplicant'
alias reexec='sudo kexec -l /boot/vmlinuz-3.18-rc6 --initrd=/boot/initramfs-3.18-rc6.img --reuse-cmdline && sudo kexec -e'
alias chrome='google-chrome-beta'

# tmux
alias tmuxn='tmux source-file $HOME/.tmux.conf'
alias tmuxd='tmux detach'
alias tmuxa='tmux attach'

# add option
alias ag='ag --hidden -S --stats'
alias alsamixer='alsamixer -gc 0'
alias dmesg='dmesg -TL'
alias pacman='sudo pacman'
alias ps='ps auxfh'

# rename
alias reboot='systemctl reboot -i'
alias poweroff='systemctl poweroff -i'
alias shutdown='sudo poweroff'
alias mixer='pavucontrol'

#suffix
alias -s rb=ruby
alias -s lua=lua
alias -s {png,jpg,PNG,JPG,JPEG}=gimmage
alias -s {mp3,mp4,avi,m4a,ts,mkv}=mplayer
alias -s pdf=evince

## network
alias wifisearch='sudo iw dev wlp6s0 scan'
alias pacs='sudo pacman -S --noconfirm'
alias yaous='yaourt -S --noconfirm'
alias pkgsearch='yaourt -Ss'
alias P='ping 8.8.8.8 -c 3'
alias renew='gem update 2>&1 /dev/null & sudo pacman -Sc --noconfirm && yaourt -Syua --devel --noconfirm && sudo pacman-optimize && sudo updatedb &'

## compile, interp
alias R='ruby'
alias mkernel='make -j5 CC="ccache gcc" CXX="ccache g++"'
alias platex='platex -kanji=utf8 -halt-on-error'
alias lualatex='lualatex -halt-on-error'
alias xelatex='xelatex -halt-on-error'
### for task
alias cgcc='gcc -O3 -std=c99 -lglut -lm -lGL -lGLU'
alias cgpp='gcc -O3 -lglut -lm -lGL -lGLU'
gascc(){gcc -m32 $1 ../libkikaigo.a && ./a.out}

## other
alias englize='export LANG=en_US.UTF-8'
alias japanize='export LANG=ja_JP.UTF-8'
