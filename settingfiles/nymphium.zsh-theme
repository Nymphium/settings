# vim: ft=sh


if [ $UID -eq 0 ]; then
	colors=("red" "magenta")

	rootprm="#"
else
	colors=("green" "blue")

	rootprm="="
fi

autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" stagedstr 'm'
zstyle ":vcs_info:git:*" unstagedstr 'a'
zstyle ":vcs_info:*" formats "%{$fg_bold[yellow]%}:%{$fg_bold[green]%}%u%c%{$fg_bold[yellow]%}:%{$fg_bold[red]%}%b"
zstyle ":vcs_info:*" actionformats "%F{red}[yabai]"
setopt prompt_subst
precmd(){vcs_info}

if [ ${SSH_CONNECTION} ]; then
	SSH="%{$fg_bold[yellow]%}<%{$fg[${colors[2]}]%}SSH%{$fg_bold[yellow]%}> "

	SSH_CLI_IP=`echo ${SSH_CONNECTION} | awk '{print $1}' | sed -e "s/\./-/g"`
fi

export PROMPT='%{$fg_bold[${colors[1]}]%}>> ${SSH}%p%{$fg[cyan]%}%c%{$fg_bold[yellow]%}${vcs_info_msg_0_}%{$fg_bold[${colors[2]}]%} ${rootprm}>>%{$reset_color%} '

