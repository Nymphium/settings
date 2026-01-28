# vim:ft=zsh

# see `spectrum_ls`
local bg_vcs="%{${bg[gray]}%}"
local fg_vcs_sep="%{${fg[gray]}%}"
local fg_normal="%{${FG[254]}%}"
local bg_normal="%{${bg[blue]}%}"
local fg_normal_sep="%{${fg[blue]}%}"
local fg_vcs_branch="%{${FG[208]}%}"
local fg_vcs_action="%{${FG[203]}%}"
local fg_vcs_status="%{${fg[green]}%}"
local fg_vim="%{${FG[155]}%}"

local nvim_icon=''
local sep=''
local branch_icon=''
local dirty_icon='󰋔'
local staged_icon=''
local unstaged_icon=''
local untracked_icon='󰧏'
local stash_icon=''
local rebase_icon=''

local icon_nvim=${NVIM:+"${fg_vim}${bg_normal}${nvim_icon}${reset_color}"}
local prompt_start="${icon_nvim}${fg_normal}${bg_normal}"

local vcs_info_git_format=" ${bg_vcs}${sep} "
vcs_info_git_format+="${fg_vcs_branch}${branch_icon}%b "
vcs_info_git_format+="${fg_vcs_status}%u%c%m"
vcs_info_git_format+="${bg_normal}"
vcs_info_git_format+="${fg_vcs_sep}${sep}"

autoload -Uz add-zsh-hook vcs_info
# add-zsh-hook precmd vcs_info # Removed: _my_prompt calls it
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "${vcs_info_git_format}"
zstyle ":vcs_info:git:*" actionformats "${vcs_info_git_format}"
zstyle ":vcs_info:git:*" unstagedstr "${unstaged_icon}"
zstyle ":vcs_info:git:*" stagedstr "${staged_icon}"
setopt prompt_subst

zstyle ':vcs_info:git*+set-message:*' hooks git-info

+vi-git-info(){
  # Get multiple paths in a single git process call
  local paths
  paths=(${(f)"$(git rev-parse --git-path logs/refs/stash --git-path rebase-merge 2>/dev/null)"})
  local stash_path=$paths[1]
  local rebase_path=$paths[2]

  # Stash check (Fast: read log file line count directly)
  if [[ -f "${stash_path}" ]]; then
    local stash_count=$(wc -l < "${stash_path}")
    # Trim whitespace
    stash_count="${stash_count//[[:space:]]/}"
    if [[ "${stash_count}" -gt 0 ]]; then
      hook_com[misc]+="[${stash_icon}${stash_count}]"
    fi
  fi

  # Rebase status check (Fast: just reading files)
  if [[ -n "${rebase_path}" ]] && [[ -e "${rebase_path}" ]]; then
    local done_=$(cat "${rebase_path}/msgnum" 2>/dev/null)
    local entire=$(cat "${rebase_path}/end" 2>/dev/null)
    if [[ -n "${done_}" ]]; then
      hook_com[misc]+="(${rebase_icon}${done_}/${entire})"
    fi
  fi
}

# | settings > master [3] > ↵
_my_prompt() {
  vcs_info

  # PROMPT="$(printf '\033]133;A\007\033]7;file://%s\033\\' "$PWD")"

  # shellcheck disable=2154
  # shellcheck disable=2034

  PROMPT="${prompt_start} %c${fg_normal_sep}${vcs_info_msg_0_}%{${reset_color}%}${bg_normal} %{${reset_color}%}${fg_normal_sep}${sep}%{${reset_color}%} "
}

add-zsh-hook precmd _my_prompt
