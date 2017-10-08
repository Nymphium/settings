[[ ! "${ZSH}" ]] && source "${HOME}/.zprofile"

if_have() {
	command -v "${1}" > /dev/null 2>&1
}

# variables {{{
	if_have tmux && {
		export TERM="tmux-256color"
	}

	if_have nvim && {
		export MANPAGER="/bin/sh -c \"col -b -x|nvim -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
		export EDITOR=nvim
	}
# }}}

# pipe filter {{{
	alias -g L='| nvim - -R'
	alias -g G='| grep -iE --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
	alias -g ぷり='|lolcat'
# }}}

### languages/tools specific {{{
	# lua/moonscript {{{
		moonv() {
			moonc -p "${1}" | nvim - -R -c "set ft=lua"
		}

		mvmc() {
			moonc -p "${1}" | luac -
		}


		luacompose() {
			local src; src=$1
			local bytecode_hex; bytecode_hex=$(luac -o /dev/stdout "${src}" | xxd -g16 | awk '{printf "%s", $2}')

			cat <<-LUA > luac.comp
#!/usr/bin/env lua

package.path = "${LUA_PATH}"
package.cpath = "${LUA_CPATH}"

local src = ""

for c in ("${bytecode_hex}"):gmatch("..") do
	src = src .. string.char(tonumber(c, 16))
end

return loadstring(src)()
			LUA

			chmod 755 luac.comp
		}

		alias luaco='luac -o /dev/null -l -l'
		alias luacl='luac -l -l'
	# }}}

	# ruby {{{
		alias irb='pry'
	# }}}

	# racket {{{
		alias tracket='racket -I typed/racket'
	# }}}

	# haskell {{{
		alias rh='runhaskell'
	# }}}

	# latex/pdf {{{
		alias platex='platex -kanji=utf8 -halt-on-error'
		alias lualatex='lualatex -halt-on-error'
		alias lualatexmk='latexmk -halt-on-error -pdf'
		alias xelatex='xelatex -halt-on-error'
		alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

		touchlatex () {
			if [ "${1}" = "" ]; then
				echo "!!!\nfilename is needed\n!!!";
				return 1;
			else
				local filename;
				if [ "${1##*.}" = "tex" ]; then
					filename=${1}
				else
					filename="${1}.tex"
				fi
				shift

				local typ; typ=${1:-article}
				shift


				cat <<-TEX > "${filename}"
\documentclass[$(echo "${@}" | sed -e 's/\s\+/,/g')]{${typ}}
\begin{document}
\maketitle
\end{document}
				TEX
			fi
		}

		pdfcomp() {
			local pdf;pdf=${1%.*}
			local pdf_uuid;pdf_uuid="/tmp/${pdf}-$(uuidgen)"
			=gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${pdf_uuid}.pdf" "${pdf}.pdf"
			mv "${pdf_uuid}.pdf" "${pdf}.pdf"
		}
	# }}}

	# git {{{
		alias gs='echo you mean \`git status\` \?'
		alias ghostscript='=gs'
		alias gpo='git push origin'
		alias gpom='git push origin master'
		alias glo='git pull origin'
		alias glom='git pull origin master'
		alias gcom='git checkout master'

		gitignore() {
			curl -L -s "https://www.gitignore.io/api/${*}"
		}
	# }}}

	# tmux {{{
		alias tmuxn='tmux source-file $HOME/.tmux.conf'
		alias tmuxd='tmux detach'
		alias tmuxa='tmux attach'
	# }}}
# }}}

# (Arch) Linux {{{
	if_have uname && [[ "$(uname -s)"  = "Linux" ]] && {
	alias pacs='sudo pacman -S --noconfirm'
	alias yaous='yaourt -S --noconfirm'
	alias pkgsearch='yaourt -Ss'

	if_have nvim && \
		vimupdate() {
			nvim --headless +NeoBundleUpdate +q
		}

	renew(){
		sudo pacman -Sc --noconfirm &&
		gem update >/dev/null 2>&1 &
		( yaourt -Syua --devel --noconfirm &&\
			sudo pacman-optimize &&\
			sudo updatedb) &
		vimupdate
	}

	if [[ ! "$(command -v open)" ]]; then
		open () {
			xdg-open "${1}" >/dev/null 2>&1 &
		}
	fi

	# misc {{{
		alias mixer='pavucontrol'
		alias ag='ag --hidden -S --stats --ignore=.git'
		alias alsamixer='alsamixer -g'
		alias dmesg='dmesg -TL'
		alias ps='ps auxfh'
		alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
		alias psg='ps aux | grep -v grep | grep'
		alias rmf='rm -rf'
		alias visudo='sudo VISUAL=nvim visudo'
		alias ibus-reload='ibus-daemon -drx && sleep 0.2 && killall ibus-ui-gtk3'
		alias C='cat'
		alias P='ping 8.8.8.8 -c 3'
		alias S='sudo'
		alias V='nvim'
		alias VD='nvim -d'
		alias vscode='code'
		alias executable='chmod 755'
		alias xin='xclip -i -selection clipboard'
		alias xout='xclip -o -selection clipboard'

		weather() {
			curl -4 "wttr.in/${1}"
		}

		mkdirc() {
			local -A opts
			zparseopts -D -A opts p
			mkdir ${(k)opts} "${@}" && cd "${@}"
		}

		# `.`* generator
		for ((i = 1; i < 11; i++)) {
			function(){
				local name;name=$(printf "."%.0s {1..${i}})
				local cmd;cmd="cd ./$(printf "../"%.0s {1..${i}})"
				alias .${name}=${cmd}
				alias .${name}l="${cmd} && l"
			}
		}
	# }}}
	}
# }}}

unset -f if_have

