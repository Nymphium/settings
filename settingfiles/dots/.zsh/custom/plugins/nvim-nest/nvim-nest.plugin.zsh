function nvr() {
  local nvn="$NVIM"

  if [[ "$nvn" == "" ]]; then
    # shellcheck disable=SC2068
    command nvim "$@"
    return $?
  fi

  # --------------

  local esc_term='<C-\><C-n>'
  _nvr_nvr() {
    # shellcheck disable=SC2068
    command nvim --server "$nvn" "$@"
  }

  _nvr_unary_cmd() {
    _nvr_nvr --remote-send "$(printf '%s:%s %q<CR>' "$esc_term" "$1" "$2")"
  }

  _nvr_vnew() {
    _nvr_unary_cmd "vnew" "$1"
  }

  _nvr_hnew() {
    _nvr_unary_cmd "new" "$1"
  }

  # --- 引数処理 ---

  # 1. -- で引数を分割
  local args_before_dash=()
  local args_after_dash=()
  local found_dash=false

  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      found_dash=true
      continue
    fi

    if $found_dash; then
      args_after_dash+=("$arg")
    else
      args_before_dash+=("$arg")
    fi
  done

  # 2. -- 以降の引数を処理
  if [[ ${#args_after_dash[@]} -gt 0 ]]; then
    _nvr_nvr --remote-tab "${args_after_dash[@]}"
    return $?
  fi

  # 3. -- 以前の引数を getopts で処理
  local split_cmd="vnew" # デフォルト

  # getoptsが引数リストを直接変更するため、-- 以前の引数リストで置き換える
  set -- "${args_before_dash[@]}"

  while getopts ":vh" opt; do
    case "$opt" in
      v)
        split_cmd="vnew"
        ;;
      h)
        split_cmd="hnew"
        ;;
      ?)
        # getopts は不明なオプションを見つけると停止するので、
        # ここでループを抜ける必要がある。
        # OPTINDをデクリメントして、不明なオプション自体を
        # ファイル引数として扱えるようにする。
        ((OPTIND--))
        break
        ;;
    esac
  done
  shift $((OPTIND-1))
  # 残った引数がファイル引数になる
  local file_args=("$@")

  # 4. ファイル引数を処理
  if [[ ${#file_args[@]} -gt 0 ]]; then
    # 最初のファイルは指定された（またはデフォルトの）分割で開く
    "_nvr_${split_cmd}" "${file_args[1]}" || return $?

    # 2つ目以降のファイルはデフォルトのvnewで開く
    local f
    for f in "${file_args[@]:1}"; do
      _nvr_vnew "$f" || return $?
    done
  else
    # ファイル引数がなく、-- 以降の引数もなければ、nvimをフォーカス
    if [[ ${#args_after_dash[@]} -eq 0 ]]; then
      _nvr_nvr --remote-send "${esc_term}"
      return $?
    fi
  fi
}
