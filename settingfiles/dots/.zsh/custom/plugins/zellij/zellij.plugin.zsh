if [[ ! (( $+commands[zellij] )) ]]; then
  return
fi

# Cache completion to fpath file — the generated script calls `_zellij "$@"`
# at top level which breaks _evalcache (comparguments outside completion context)
if [[ ! -f "$ZSH_CACHE_DIR/completions/_zellij" ]]; then
  zellij setup --generate-completion zsh > "$ZSH_CACHE_DIR/completions/_zellij"
fi

# auto-start zellij for interactive shells
if [[ -o interactive ]] && [[ -z "$ZELLIJ" ]]; then
  while true; do
    local session_names
    local session_output
    session_output="$(zellij list-sessions -s 2>/dev/null)"
    if [[ -n "$session_output" ]]; then
      session_names=("${(@f)session_output}")
      # Attach to the first available session
      zellij attach "${session_names[1]}"
    else
      break
    fi
  done

  # If no sessions are left to attach to, start a new one and exit the shell when it's closed
  exec zellij
fi
