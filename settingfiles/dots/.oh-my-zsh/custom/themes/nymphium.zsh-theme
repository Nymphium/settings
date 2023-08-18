# vim:ft=zsh

# see `spectrum_ls`
local bg_gray=${BG[244]}
local fg_gray=${FG[241]}
local fg_white=${FG[254]}
local bg_blue=${BG[033]}
local fg_blue=${FG[026]}
local fg_orange=${FG[208]}
local fg_red=${FG[009]}
local fg_green=${FG[084]}

autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes false
zstyle ":vcs_info:git:*" formats " %{${bg_gray}${fg_blue}%} %{${fg_orange}%}%{${fg_green}%}%m %{${fg_orange}%}%b %{${bg_blue}${fg_gray}%}"
# shellcheck disable=2154
zstyle ":vcs_info:git:*" actionformats " %{${bg_gray}${fg_blue}%} %{${fg_orange}%} %b%{${fg_green}%}%{${fg_red}%} 󰋔 %{${bg_blue}${fg_gray}%}"
setopt prompt_subst

zstyle ':vcs_info:git*+set-message:*' hooks git-info

+vi-git-info(){
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
    ginfo=$(git status --porcelain)
    contents=()
    if echo -n "${ginfo}" | grep '^\s*A' &>/dev/null; then
      # shellcheck disable=2154
      contents+=''
    fi

    if echo -n "${ginfo}" | grep '^\s*M' &>/dev/null; then
      # shellcheck disable=2154
      contents+=''
    fi

    if echo -n "${ginfo}" | grep '^\s*??' &>/dev/null; then
      contents+='󰧏'
    fi

    local COUNT; COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [[ "${COUNT}" -gt 0 ]]; then
      if [[ "${#contents}" -gt 0 ]]; then
        contents+='|'
      fi
      contents+="${COUNT}"
    fi

    if [[ "${#contents}" -gt 0 ]]; then
      hook_com[misc]='['
      hook_com[misc]+=$(printf "%s" ${contents[@]})
      hook_com[misc]+=']'
    fi

  fi
}

#  settings   master[3]   ↵
_my_prompt() {
  vcs_info

  # shellcheck disable=2154
  # shellcheck disable=2034
  PROMPT="%{${bg_blue}%}%{${fg_white}%}%B"
  PROMPT+=" %c"
  PROMPT+="${vcs_info_msg_0_}"
  PROMPT+="%{${bg_blue}%} %{${reset_color}%}%{${fg_blue}%}"
  PROMPT+="%b%{${reset_color}%} "
}

add-zsh-hook precmd _my_prompt

