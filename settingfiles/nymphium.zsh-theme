# vim: ft=sh


if [ $UID -eq 0 ]; then
	colors=("red" "magenta")

	rootprm="#"
else
	colors=("green" "blue")

	rootprm="="
fi

GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
RED="%{$fg_bold[red]%}"
CYAN="%{$fg_bold[cyan]%}"
COL1="%{$fg_bold[${colors[1]}]%}"
COL2="%{$fg_bold[${colors[2]}]%}"
COL3="%{$fg_bold[${colors[3]}]%}"


autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" stagedstr 'm'
zstyle ":vcs_info:git:*" unstagedstr 'a'
zstyle ":vcs_info:*" formats "%u%c${YERLLOW}:${RED}%b"
zstyle ":vcs_info:*" actionformats "%F{red}[yabai]"
setopt prompt_subst

function _git_untracked() {
	if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
		__untracked="${YELLOW}:${GREEN}"
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
		SSH="%{$fg_bold[yellow]%}<${COL2}SSH${YELLOW}> "

		SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
	fi

	PROMPT="${COL1}>> ${SSH}%p${CYAN}%c$(_git_untracked)${vcs_info_msg_0_}${COL2} ${rootprm}>>%{$reset_color%}"
}


add-zsh-hook precmd(){_my_prompt}

