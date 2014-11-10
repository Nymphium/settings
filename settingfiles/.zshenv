# vim: ft=sh

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
# alias less='vim -R'
alias reexec='sudo kexec -l /boot/vmlinuz-3.17.1 --initrd=/boot/initramfs-3.17.1.img --reuse-cmdline && sudo kexec -e'

#suffix
alias -s rb=ruby
alias -s {png,jpg,PNG,JPG,JPEG}=gimmage
alias -s {mp3,mp4,avi}=mplayer
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
alias cgcc='gcc -std=c99 -lglut -lm -lGL -lGLU'
alias gpp='g++'
alias R='ruby'
alias mkernel='make -j6 CC="ccache gcc" CXX="ccache g++"'

## other
alias englize='export LANG=en_US.UTF-8'
