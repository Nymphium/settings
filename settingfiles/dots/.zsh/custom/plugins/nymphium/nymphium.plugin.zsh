# vim:ft=zsh

# Load datetime module for EPOCHSECONDS
zmodload zsh/datetime

# --- Persistent Cache (Global) ---
# This single global associative array stores state and rendered color strings.
typeset -gA _theme_nymphium_cache
_theme_nymphium_cache=(
  last_update 0
  mode ""
  is_darwin 0
)
[[ "$(uname)" == "Darwin" ]] && _theme_nymphium_cache[is_darwin]=1

# --- Color/Style Updater ---
_nyphium_update_colors() {
  local now=$EPOCHSECONDS
  local need_refresh=0
  
  # Check if we need to re-run the heavy 'defaults read'
  if (( now - _theme_nymphium_cache[last_update] >= 30 )) || [[ -z "$_nymphium_cache[mode]" ]]; then
    need_refresh=1
  fi

  if [[ $need_refresh -eq 1 ]]; then
    _theme_nymphium_cache[last_update]=$now
    local mode="dark_mode"
    if [[ $_theme_nymphium_cache[is_darwin] -eq 1 ]]; then
      if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
        mode="dark_mode"
      else
        mode="light_mode"
      fi
    fi

    if [[ "$mode" != "$_theme_nymphium_cache[mode]" ]] || [[ -z "$_nymphium_cache[fg_normal]" ]]; then
      _theme_nymphium_cache[mode]="$mode"
      local white light_blue blue pink violet green
      if [[ "$mode" == "dark_mode" ]]; then
        white="#CCCCCC" light_blue="#428CD4" blue="#004E9A" pink="#FF9CDA" violet="#EA4492" green="#afff5f"
      else
        white="#FFFFFF" light_blue="#A5CAD2" blue="#758EB7" pink="#FF7B89" violet="#8A5082" green="#5f8700"
      fi

      # Store rendered escape sequences in the global cache
      _theme_nymphium_cache[fg_vcs_branch]="%F{${pink}}"
      _theme_nymphium_cache[fg_vcs_status]="%F{${violet}}"
      _theme_nymphium_cache[bg_vcs]="%K{${blue}}"
      _theme_nymphium_cache[fg_vcs_sep]="%F{${blue}}"
      _theme_nymphium_cache[fg_normal]="%F{${white}}"
      _theme_nymphium_cache[bg_normal]="%K{${light_blue}}"
      _theme_nymphium_cache[fg_normal_sep]="%F{${light_blue}}"
      _theme_nymphium_cache[fg_vim]="%F{${green}}"

      # Update vcs_info formats only when mode changes
      local sep=$icons[sep] branch=$icons[branch]
      local fmt=" ${_theme_nymphium_cache[bg_vcs]}${sep} "
      fmt+="${_theme_nymphium_cache[fg_vcs_branch]}${branch}%b "
      fmt+="${_theme_nymphium_cache[fg_vcs_status]}%u%c%m"
      fmt+="${_theme_nymphium_cache[bg_normal]}"
      fmt+="${_theme_nymphium_cache[fg_vcs_sep]}${sep}"

      zstyle ":vcs_info:git:*" formats "$fmt"
      zstyle ":vcs_info:git:*" actionformats "$fmt"
    fi
  fi

  # ALWAYS populate the 'colors' array in the caller's scope from our global cache
  colors=(
    fg_vcs_branch  "$_theme_nymphium_cache[fg_vcs_branch]"
    fg_vcs_status  "$_theme_nymphium_cache[fg_vcs_status]"
    bg_vcs         "$_theme_nymphium_cache[bg_vcs]"
    fg_vcs_sep     "$_theme_nymphium_cache[fg_vcs_sep]"
    fg_normal      "$_theme_nymphium_cache[fg_normal]"
    bg_normal      "$_theme_nymphium_cache[bg_normal]"
    fg_normal_sep  "$_theme_nymphium_cache[fg_normal_sep]"
    fg_vim         "$_theme_nymphium_cache[fg_vim]"
  )
}

# --- VCS Info Setup ---
autoload -Uz add-zsh-hook vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes false
zstyle ":vcs_info:git:*" unstagedstr ''
zstyle ":vcs_info:git:*" stagedstr ''
setopt prompt_subst

zstyle ':vcs_info:git*+set-message:*' hooks git-info

+vi-git-info(){
  # Accesses 'icons' and 'colors' via dynamic scoping
  local paths
  paths=(${(f)"$(git rev-parse --git-path logs/refs/stash --git-path rebase-merge 2>/dev/null)"})
  local stash_path=$paths[1]
  local rebase_path=$paths[2]

  local git_status timeout_cmd=""
  if (( $+commands[timeout] )); then timeout_cmd="timeout 0.1"
  elif (( $+commands[gtimeout] )); then timeout_cmd="gtimeout 0.1"
  fi

  if [[ -n "$timeout_cmd" ]]; then
    git_status=$(${(z)timeout_cmd} git status --porcelain --untracked-files=no 2>/dev/null)
  else
    git_status=$(git status --porcelain --untracked-files=no 2>/dev/null)
  fi

  if [[ -n "${git_status}" ]]; then
    local status_icons=""
    [[ "${git_status}" =~ '^[[:graph:]]' ]] && status_icons+="${icons[staged]}"
    [[ "${git_status}" =~ '^[[:space:]][[:graph:]]' ]] || [[ "${git_status}" =~ '^.[[:graph:]]' ]] && status_icons+="${icons[unstaged]}"
    
    if [[ -n "${status_icons}" ]]; then
       hook_com[misc]+="${colors[fg_vcs_status]}${status_icons}"
    fi
  fi

  if [[ -f "${stash_path}" ]]; then
    local stash_count=$(wc -l < "${stash_path}")
    stash_count="${stash_count//[[:space:]]/}"
    if [[ "${stash_count}" -gt 0 ]]; then
      hook_com[misc]+="[${icons[stash]}${stash_count}]"
    fi
  fi

  if [[ -n "${rebase_path}" ]] && [[ -e "${rebase_path}" ]]; then
    local done_=$(cat "${rebase_path}/msgnum" 2>/dev/null)
    local entire=$(cat "${rebase_path}/end" 2>/dev/null)
    if [[ -n "${done_}" ]]; then
      hook_com[misc]+="(${icons[rebase]}${done_}/${entire})"
    fi
  fi
}

# --- Prompt Rendering ---
_my_prompt() {
  # These are available to any function we call (dynamic scoping)
  local -A icons=(
    nvim      ''
    sep       ''
    branch    ''
    staged    ''
    unstaged  ''
    stash     ''
    rebase    ''
  )
  local -A colors

  # This will fill the 'colors' array (and update global cache if needed)
  _nyphium_update_colors
  
  vcs_info

  local reset="%f%k"
  local icon_nvim=${NVIM:+"${colors[fg_vim]}${colors[bg_normal]}${icons[nvim]}${reset}"}
  local prompt_start="${icon_nvim}${colors[fg_normal]}${colors[bg_normal]}"

  PROMPT="${prompt_start} %c${colors[fg_normal_sep]}${vcs_info_msg_0_}${reset}${colors[bg_normal]} ${reset}${colors[fg_normal_sep]}${icons[sep]}${reset} "
}

add-zsh-hook precmd _my_prompt
