# vim: ft=sh


if [ $UID -eq 0 ]; then
	colors=("red" "magenta")

	rootprm="#"
else
	colors=("green" "blue")

	rootprm="="
fi

_GREEN="%{$fg_bold[green]%}"
_YELLOW="%{$fg_bold[yellow]%}"
_RED="%{$fg_bold[red]%}"
_CYAN="%{$fg_bold[cyan]%}"
_COL1="%{$fg_bold[${colors[1]}]%}"
_COL2="%{$fg_bold[${colors[2]}]%}"


autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" stagedstr 'm'
zstyle ":vcs_info:git:*" unstagedstr 'a'
zstyle ":vcs_info:*" formats "%u%c${_YELLOW}:${_RED}%b"
zstyle ":vcs_info:*" actionformats "%F{red}[yabai]"
setopt prompt_subst

function _git_untracked() {
	if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
		__untracked="${_YELLOW}:${_GREEN}"
		__git_status=$(git status -s 2> /dev/null)

		if  git status -s 2> /dev/null | grep "^??" > /dev/null 2>&1; then
			__untracked+="u"
		fi

		printf %s ${__untracked}
	fi
}

function _my_prompt() {
	vcs_info

	if [ ${SSH_CONNECTION} ]; then
		SSH="%{$fg_bold[yellow]%}<${_COL2}SSH${_YELLOW}> "

		SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
	fi

	PROMPT="${_COL1}>> ${SSH}%p${_CYAN}%c$(_git_untracked)${vcs_info_msg_0_}${_COL2} ${rootprm}>>%{$reset_color%} "
}


add-zsh-hook precmd(){_my_prompt}

