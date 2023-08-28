# vim:ft=zsh

# see `spectrum_ls`
local bg_vcs="%{${BG[244]}%}"
local fg_vcs_sep="%{${FG[241]}%}"
local fg_normal="%{${FG[254]}%}"
local bg_normal="%{${BG[033]}%}"
local fg_normal_sep="%{${FG[026]}%}"
local fg_vcs_branch="%{${FG[208]}%}"
local fg_vcs_action="%{${FG[203]}%}"
local fg_vcs_status="%{${FG[084]}%}"
local fg_vim="%{${FG[155]}%}"

local vim_icon=''
local sep=''
local branch_icon=''
local dirty_icon='󰋔'
local staged_icon=''
local unstaged_icon=''
local untracked_icon='󰧏'
local stash_icon=''
local rebase_icon=''

local icon_vim=${VIM:+"${fg_vim}${vim_icon}${fg_normal}"}
local prompt_start="${fg_normal}${icon_vim}"

local vcs_info_git_format=" ${bg_vcs}${sep} "
vcs_info_git_format+="${fg_vcs_branch}${branch_icon}%b "
vcs_info_git_format+="${fg_vcs_status}%m${bg_normal}"
vcs_info_git_format+="${fg_vcs_sep}${sep}"

autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes false
zstyle ":vcs_info:git:*" formats "${vcs_info_git_format}"
zstyle ":vcs_info:git:*" actionformats "${vcs_info_git_format}"
setopt prompt_subst

zstyle ':vcs_info:git*+set-message:*' hooks git-info

+vi-git-info(){
  local ginfo=$(git status --porcelain 2>&1)
  if [[ $? -eq 0 ]]; then
    contents=()

    if [[ "${ginfo}" =~ 'UU[[:space:]]' ]]; then
      contents+="${dirty_icon}"
    fi

    if [[ "${ginfo}" =~ '[[:space:]]A[[:space:]]' ]]; then
      # shellcheck disable=2154
      contents+="${staged_icon}"
    fi

    if [[ "${ginfo}" =~ '[[:space:]]M[[:space:]]' ]]; then
      # shellcheck disable=2154
      contents+="${unstaged_icon}"
    fi

    if [[ "${ginfo}" =~ '[[:space:]]\?\?[[:space:]]' ]]; then
      contents+="${untracked_icon}"
    fi

    local COUNT; COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [[ "${COUNT}" -gt 0 ]]; then
      contents+="[${stash_icon}${COUNT}]"
    fi

    if [[ "${#contents}" -gt 0 ]]; then
      hook_com[misc]="${fg_vcs_action}"

      local rebmergpath="$(git rev-parse --git-path 'rebase-merge/')"
      if [[ $? -eq 0 ]] && [[ -e "${rebmergpath}"  ]]; then
        local done_=$(cat "${rebmergpath}msgnum")
        local entire=$(cat "${rebmergpath}end")
        hook_com[misc]+="(${rebase_icon}${done_}/${entire})"
      fi

      hook_com[misc]+="${fg_vcs_status}"
      hook_com[misc]+="${(j::)contents}"
    fi
  fi
}

# | settings > master [3] > ↵
_my_prompt() {
  vcs_info

  # shellcheck disable=2154
  # shellcheck disable=2034
  PROMPT="${bg_normal}"

  PROMPT+="${prompt_start} %c${fg_normal_sep}"
  PROMPT+="${vcs_info_msg_0_}%{${reset_color}%}"
  PROMPT+="${bg_normal} %{${reset_color}%}${fg_normal_sep}${sep}%{${reset_color}%} "
}

add-zsh-hook precmd _my_prompt

