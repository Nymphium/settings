if_have() {
	command -v "${1}" > /dev/null 2>&1
}

if_have direnv && eval "$(direnv hook zsh)"

if_have tmux && {
	setterm() {
		if [[ $(infocmp $1 >/dev/null 2>&1) ]]; then
			echo $1
			return 0
		else
			return 1
		fi
	}

	# TERM=$(setterm tmux-256color || setterm screen-256color || setterm xterm-256color || echo $TERM)
	TERM=tmux-256color
	export TERM

	unset setterm
}

if [ -e "${HOME}"/.nix-profile/etc/profile.d/nix.sh ]; then . "${HOME}"/.nix-profile/etc/profile.d/nix.sh; fi
if [ -e "${HOME}/.nix-profile/share/nix-direnv/direnvrc" ]; then . "${HOME}/.nix-profile/share/nix-direnv/direnvrc"; fi

[[ ! "${ZSH}" ]] && source "${HOME}/.zprofile"

export LANG=${LANG:-en_US.UTF-8}

# pipe filter {{{
	alias -g G='| grep'
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
	# }}}

	# latex/pdf {{{
		alias platex='platex -kanji=utf8 -halt-on-error'
		alias lualatex='lualatex -halt-on-error'
		alias xelatex='xelatex -halt-on-error'
		alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

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
		alias tmuxd='tmux detach'
		alias tmuxa='tmux attach'
	# }}}
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
		alias alsamixer='alsamixer -g'
		alias dmesg='dmesg -TL'
		weather() {
			curl -4 "wttr.in/${1}"
		}

	# }}}
	}
# }}}
### }}}

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

alias ps='ps auxfh'
alias ag='ag --hidden -S --stats --ignore=.git'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
alias rmf='rm -rf'
alias C='cat'
alias P='ping 8.8.8.8 -c 3'
alias S='sudo'
alias SV='sudoedit'

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
		if [[ "$(infocmp -x tmux-256color >/dev/null 2>&1)" ]]; then
			export TERM=tmux-256color
		fi

		local unused
		unused=$(tmux list-sessions | awk '$11!~/.+/{sub(/[^0-9]/,"");print $1;exit}')

		if [[ ! -z "${unused}" ]]; then
			tmux -u -2 -CC attach -t "${unused}"
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

function gitignore() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}
