# vim: ft=sh

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

export PROMPT='%{$fg_bold[${colors[1]}]%}>> ${SSH}%p%{$fg[cyan]%}%c%{$reset_color%}$(git_prompt_info)%{$fg_bold[${colors[2]}]%} ${rootprm}>>%{$reset_color%} '

# display branch at that current repo to prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}::%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$reset_color%}%{$fg_bold[red]%}?%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

