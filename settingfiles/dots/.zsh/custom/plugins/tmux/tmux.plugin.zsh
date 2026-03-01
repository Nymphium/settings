if [[ ! (( $+commands[tmux] )) ]]; then
  return
fi

# auto-start tmux for interactive shells
if [[ -o interactive ]] && [[ -z "$TMUX" ]]; then
  while true; do
    local detached_session
    detached_session="$(tmux list-sessions -F '#{session_name}' -f '#{?session_attached,,1}' 2>/dev/null | head -1)"

    if [[ -n "$detached_session" ]]; then
      tmux -u attach-session -t "$detached_session"
    else
      tmux -u new-session
    fi
  done
  exit
fi
