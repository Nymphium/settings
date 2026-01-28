# ------------------------------------------------------------------------------
# Skim (sk) Custom Plugin
# ------------------------------------------------------------------------------

# 1. デフォルトオプションの設定
# --ansi: 色情報を維持して表示
# --reverse: プロンプトを上に、候補を下に表示（fzfのデフォルトに近い挙動）
# 既存の設定がある場合は上書きせず、先頭に追加します。
ORIG_SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS"
SKIM_DEFAULT_OPTIONS="--ansi --reverse"

if [[ "$(command -v bat)" ]]; then
  SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS --preview 'bat --style=numbers --color=always --line-range :500 {}'"
fi
SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS $ORIG_SKIM_DEFAULT_OPTIONS"
export SKIM_DEFAULT_OPTIONS

# fdを使ってファイル検索（隠しファイルも含めるが .git は除外）
if [[ "$(command -v fd)" ]]; then
  export SKIM_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
fi

# Ctrl+T (ファイル検索) 用のコマンド設定
export SKIM_CTRL_T_COMMAND="$SKIM_DEFAULT_COMMAND"

# 2. グローバルエイリアスの設定
# 'S' をパイプと skim コマンドに展開します。
# これにより 'ls S' は 'ls | sk' と解釈されます。
# ls だけでなく 'find . S' や 'git branch S' のように他のコマンドでも使えます。
alias -g S='| sk'

# (オプション) もし通常のエイリアスの方が好みであれば、以下のような設定も可能です
# alias lss='ls | sk'

# 1. Ctrl + R でコマンド履歴を検索・実行
function skim-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  
  # 履歴全体から検索 (重複排除あり)
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --tac --no-sort --query "$LBUFFER" --preview-window hidden) )
  
  local ret=$?
  if [ -n "$selected" ]; then
    # 選択された行からコマンド部分のみ抽出
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
  local selected
  if [ -n "$SKIM_CTRL_T_COMMAND" ]; then
    selected=$(eval "$SKIM_CTRL_T_COMMAND" | sk)
  else
    selected=$(sk)
  fi
  
  if [ -n "$selected" ]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
}
zle -N skim-file-widget
bindkey '^t' skim-file-widget

# コマンド名: skill
# 使い方: skill と打つとプロセス一覧が出て、EnterでKill
if [[ "$(command -v procs)" ]]; then
  skill() {
    local pid
    # 自分のプロセス以外を表示し、選択したらPIDを取得
    pid=$(procs | sk --header-lines=1 --query "$1" | awk '{print $1}')

    if [ -n "$pid" ]; then
      echo $pid | xargs kill -${1:-9}
      echo "Process $pid killed."
    fi
  }
fi

source <(sk --shell zsh)
