# vim: ft=sh


if [[ "${UID}" -eq 0 ]]; then
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

function _my_prompt() {
	vcs_info
	local SSH=""
	local HAS_SSH

	[[ "${TMUX}" ]] && HAS_SSH=$(tmux showenv SSH_CONNECTION 2> /dev/null | sed -e "s/SSH_CONNECTION//")

	if [[ ! "${#SSH_CONNECTION}" -eq 0 ]] && [[ "${#HAS_SSH}" -gt 2 ]]; then
		SSH="%{$fg_bold[yellow]%}<${_COL2}SSH${_YELLOW}> "
	else
		unset SSH
		unset SSH_CONNECTION
		[[ "${TMUX}" ]] && tmux setenv -u SSH_CONNECTION
	fi

	PROMPT="${_COL1}>> ${SSH}%p${_CYAN}%c$(git status 2>/dev/null | awk 'NR==1($1=="On" || $2 == "detached"){printf "${_YELLOW}:${_GREEN}"}$1=="Untracked"{print "u"}')${vcs_info_msg_0_}${_COL2} ${rootprm}>>%{$reset_color%} "
}

add-zsh-hook precmd(){_my_prompt}

