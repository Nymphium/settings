if_have() {
	command -v "${1}" > /dev/null 2>&1
}

if_have direnv && eval "$(direnv hook zsh)"

if [ -e "${HOME}"/.nix-profile/etc/profile.d/nix.sh ]; then . "${HOME}"/.nix-profile/etc/profile.d/nix.sh; fi

[[ ! "${ZSH}" ]] && source "${HOME}/.zprofile"

# variables {{{
	if_have tmux && {
		TERM="tmux-256color"
		export TERM
	}

# }}}

# pipe filter {{{
	alias -g G='| grep'
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
		if_have luarocks && eval "$(luarocks path --bin)"
	# }}}

	# ruby {{{
		alias irb='pry'
		if_have ruby && path+=$(ruby -e 'print Gem.user_dir')/bin
	# }}}

	# racket {{{
		alias tracket='racket -I typed/racket'
	# }}}

	# ocaml {{{
		if_have opam && {
	source "${HOME}"/.opam/opam-init/init.zsh 1>&2 /dev/null
	eval "$(opam config env)"

		}
	# }}}

	# java {{{
		if_have java && {
			JAVA_HOME=${JAVA_HOME:-/opt/java}; export JAVA_HOME
		}
	# }}}

	# js {{{
		[[ -d /usr/share/nvm ]] && source /usr/share/nvm/init-nvm.sh

		if_have node && {
			path+=(./node_modules/.bin);
			path+=(${HOME}/node_modules/.bin)
		}

		if_have yarn && path+=("${HOME}"/'.config/yarn/global/node_modules/.bin')
	# }}}

	# dotnet {{{
		if_have dotnet && path+=("${HOME}"/'.dotnet/tools')
	#

	# haskell {{{
		alias rh='runhaskell'
	# }}}

	# latex/pdf {{{
		alias platex='platex -kanji=utf8 -halt-on-error'
		alias lualatex='lualatex -halt-on-error'
		alias lualatexmk='latexmk -halt-on-error -pdf'
		alias xelatex='xelatex -halt-on-error'
		alias luajitlatex='luajittex --fmt=luajitlatex.fmt'
		alias mozillacurl='curl --user-agent "Mozilla/5.0"'

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
% \maketitle
\end{document}
				TEX

				touch "${filename}.latexmain"
			fi
		}

		pdfcomp () {
				local pdf
				pdf=${1%.*}
				local pdf_uuid
				pdf_uuid="/tmp/${pdf}-$(uuidgen)"
				=gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true  -dColorImageResolution=300  -dNOPAUSE -dQUIET -dBATCH -dNOCACHE -dNOBIND -sOutputFile="${pdf_uuid}.pdf" "${pdf}.pdf"
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

# docker {{{
	# alias docker-imageid='docker container ls --format "{{.ID}}"'
	docker-id-cname() {
		docker ps -a --filter "ancestor=$1" --format "{{.ID}}"
	}

	docker-logs-cname() {
		docker logs $(docker-id-cname $1)
	}

# }}}

# (Arch) Linux {{{
	if_have uname && [[ "$(uname -s)"  = "Linux" ]] && {
	alias pacs='yay --nouseask'
	alias pkgsearch='yay -Ss'

	if_have nvim && \
		vimupdate() {
			nvim --headless +'call dein#update()' +message +q
		}

		nvwrap() {
			nvim +"term rlwrap $1"
		}

	renew(){
		sudo pacman -Sc --noconfirm &&
		( yay -Syu --nouseask &&\
			# sudo pacman-optimize &&\
			((command -v pacman-optimize >/dev/null 2>&1 && sudo pacman-optimize); (command -v pacman-db-upgrade >/dev/null 2>&1 && sudo pacman-db-upgrade)   )
			sudo updatedb) &
		vimupdate
	}

	if [[ ! "$(command -v open)" ]]; then
		open () {
			xdg-open "${1}" >/dev/null 2>&1 &
		}
	fi

	# misc {{{
		alias 4date='date +%m%d'
		alias mixer='pavucontrol'
		alias ag='ag --hidden -S --stats --ignore=.git'
		alias alsamixer='alsamixer -g'
		alias dmesg='dmesg -TL'
		alias ps='ps auxfh'
		alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
		alias psg='ps aux | grep -v grep | grep'
		alias rmf='rm -rf'
		alias ibus-reload='ibus-daemon -drx && sleep 0.2 && killall ibus-ui-gtk3'
		alias C='cat'
		alias P='ping 8.8.8.8 -c 3'
		alias S='sudo'
		# alias V='nvim'
		alias SV='sudoedit'
		alias vscode='code'
		alias executable='chmod 755'
		alias xin='xclip -i -selection clipboard'
		alias xout='xclip -o -selection clipboard'

		if [[ "${NVIM_LISTEN_ADDRESS}" ]]; then
			EDITOR='nvr -s -cc sp'
		else
			EDITOR='nvim'
		fi
		# EDITOR='nvr -s'
		# alias V='nvr -s'

		export EDITOR
		V() { eval "${EDITOR}" "${@}" }

		alias -g L='| V -'
		alias VD='V -d'
		alias visudo='sudo VISUAL=V visudo'
		MANPAGER="/bin/sh -c \"col -b -x | ${EDITOR} -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
		export MANPAGER

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
### }}}

# load personal preferences {{{
() {
	local RCD=$HOME/.zsh.d
	if [[ -d "${RCD}" ]] && [[ -n "$(ls -A "${RCD}")" ]] ; then
		for f in "${RCD}"/*; do
			source "${f}"
		done
	fi
}

if_have add_comp_ignores && {
	add_comp_ignores class \
		bcf run.xml
}
# }}}

# interactive shell settings {{{
# no flow control
stty -ixon

if [[ ! "${DISPLAY}" ]]; then
	stty iutf8
fi

## tmux attach {{{
if [[ "$(command -v tmux)" ]] && [[ ! "${TMUX}" ]]; then
	() {
		local unused
		unused=$(tmux list-sessions | awk '$11!~/.+/{sub(/[^0-9]/,"");print $1;exit}')

		if [[ ! -z "${unused}" ]]; then
			tmux -u -2 attach -t "${unused}"
		else
			exec tmux -u -2 -l
		fi
	}
fi
## }}}

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word
bindkey -r '^[l'
# }}}

unset -f if_have

