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
zstyle ":vcs_info:git:*" formats "%u%c${_YELLOW}:${_RED}%b"
zstyle ":vcs_info:git:*" actionformats "%F{red}[yabai]%{$reset_color%}"
setopt prompt_subst

function git_status() {
	git status 2>/dev/null | awk 'NR==1&&($1=="On" || $2 == "detached"){printf "${_YELLOW}:${_GREEN}"}$1=="Untracked"{printf "u"}'
}

function git_prompt_stash_count {
	local COUNT; COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
	if [ "$COUNT" -gt 0 ]; then
		echo "${_COL1}[${_RED}$COUNT${_COL1}]"
	fi
}

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

	PROMPT="${_COL1}>> ${SSH}%p${_CYAN}%c$(git_status)${vcs_info_msg_0_}$(git_prompt_stash_count)${_COL2} ${rootprm}>>%{$reset_color%} "
}

add-zsh-hook precmd(){_my_prompt}

