# vim: ft=sh


__prompt_merge(){
	git_stat=`git status 2>/dev/null`

	if [ $git_stat ]; then
		COLOR1="%{$fg_bold[yellow]%}"
		COLOR2="%{$fg_bold[green]%}"
		is_add=`echo ${git_stat} | grep -E "^\s+\(use \"git add <file>...\" to update what will be committed\)$"`
		is_committed=`echo ${git_stat} | grep -E "^Changes to be committed:"`

		[ ${is_add} ] && not_added="a"
		[ ${is_committed} ] && not_committed="c"

		echo ${COLOR1}:${COLOR2}${not_added}${not_committed}`git_prompt_status`${COLOR1}:
	fi
}


if [ $UID -eq 0 ]; then
	colors=("red" "magenta")

	rootprm="#"
else
	colors=("green" "blue")

	rootprm="="
fi

if [ ${SSH_CONNECTION} ]; then
	SSH="%{$fg_bold[yellow]%}<%{$fg[${colors[2]}]%}SSH%{$fg_bold[yellow]%}> "

	SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
fi

export PROMPT='%{$fg_bold[${colors[1]}]%}>> ${SSH}%p%{$fg[cyan]%}%c%{$fg_bold[yellow]%}$(__prompt_merge)$(git_prompt_info)%{$fg_bold[${colors[2]}]%} ${rootprm}>>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="u"
ZSH_THEME_GIT_PROMPT_CLEAN=""

