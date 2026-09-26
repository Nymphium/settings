# ------------------------------------------------------------------------------
# Skim (sk) Custom Plugin
# ------------------------------------------------------------------------------

if (( ! $+commands[sk] )); then
  return
fi

# 1. デフォルトオプションの設定
ORIG_SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS"
SKIM_DEFAULT_OPTIONS="--ansi --reverse"

if (( $+commands[bat] )); then
  SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS --preview 'bat --style='numbers,grid' --color=always --line-range :500 {}'"
fi
SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS $ORIG_SKIM_DEFAULT_OPTIONS"
export SKIM_DEFAULT_OPTIONS

# fdを使ってファイル検索
if (( $+commands[fd] )); then
  export SKIM_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
fi

export SKIM_CTRL_T_COMMAND="$SKIM_DEFAULT_COMMAND"

# 2. グローバルエイリアスの設定
alias -g S='| sk'

# 1. Ctrl + R でコマンド履歴を検索・実行
function skim-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ 	]*[0-9]+\*+[ 	]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --tac --no-sort --query "$LBUFFER" --preview-window hidden) )
  
  local ret=$?
  if [ -n "$selected" ]; then
    num=${selected[1]}
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle -N skim-history-widget
bindkey '^R' skim-history-widget

# 2. Ctrl + T でファイルを検索してコマンドラインに挿入
function skim-file-widget() {
  local current_dir=$PWD
  local result lines key selected full_path rel_path
  
  while true; do
    result=$(
        {
          echo "📁${current_dir/#$HOME/~}";
          echo "Enter: Select | Left: Up | Right: Dig";
          echo "..";
          builtin cd "$current_dir" \
          && fd --max-depth 1 --hidden --follow --exclude .git \
        } \
        | sk --ansi \
             --prompt "  🔎 " \
             --bind "left:accept(up),right:accept(dig),enter:accept(accept)" \
             --header-lines 2 \
             --preview "if [[ -d {} ]]; then \
                          ls --color -Fhal {}; \
                        else \
                          bat --style='numbers,grid' --color=always -S --line-range :500 {}; \
                        fi 2>/dev/null" )

    # Exit if skim was cancelled (Esc) or failed
    [[ $? -ne 0 || -z "$result" ]] && break

    # Split output into lines, preserving empty elements
    lines=("${(@f)result}")

    if [[ "$result" == $' '* ]]; then
      # Enter was pressed (first line of result is a newline)
      op=""
      selected="${lines[2]}"
    else
      # A registered key (left, ctrl-g, etc.) was pressed
      op="${lines[1]}"
      selected="${lines[2]}"

      if [[ -z "$selected" ]]; then
        # Safety check: if key is empty, treat as Enter
        selected="$op"
        op=""
      fi
    fi

    # Resolve full absolute path
    if [[ "$selected" == ".." ]]; then
      full_path=$(builtin cd "$current_dir/.." && pwd)
    else
      full_path="${current_dir%/}/$selected"
    fi

    if [[ ! -d "$full_path" ]]; then
      op=accept
    fi

    # Logic based on op and selection
    if [[ "$op" == "dig" ]]; then
      current_dir="$full_path"
      continue
    elif [[ "$op" == "up" ]]; then
      current_dir=$(builtin cd "$current_dir/.." && pwd)
      continue
    elif [[ "$op" != "accept" ]]; then
      continue
    fi

    # Accept selection: Either a file was selected via Enter, or Alt-Enter was pressed
    if [[ -n "$full_path" ]]; then
      # Convert the absolute path back to a relative path from the shell's current working directory
      if [[ "$full_path" == "$PWD" ]]; then
        rel_path="."
      elif [[ "$full_path" == "$PWD"/* ]]; then
        rel_path="${full_path#$PWD/}"
      else
        # If outside PWD, use ~ for home-relative paths
        rel_path="${full_path/#$HOME/~}"
      fi

      # Insert into LBUFFER with a leading space if needed
      [[ -n "$LBUFFER" && "$LBUFFER" != *[[:space:]] ]] && LBUFFER+=" "
      LBUFFER+="${rel_path}"
    fi
    break
  done

  zle reset-prompt
}
zle -N skim-file-widget
bindkey '^t' skim-file-widget

if (( $+commands[procs] )); then
  # skill [query] [signal]
  skill() {
    local pid
    pid=$(procs | sk --header-lines=1 --query "$1" | awk '{print $1}')
    if [ -n "$pid" ]; then
      kill -${2:-9} $pid && echo "Process $pid killed."
    fi
  }
fi

_evalcache sk --shell zsh
