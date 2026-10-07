(( $+commands[tmux] )) || return

# auto-start tmux for interactive shells outside herdr; drop to a plain shell if tmux fails
if [[ -o interactive ]] && [[ -z "$TMUX" && -z "$HERDR_ENV" ]]; then
  while true; do
    local detached_session
    detached_session="$(tmux list-sessions -F '#{session_name}' -f '#{?session_attached,,1}' 2>/dev/null | head -1)"

    if [[ -n "$detached_session" ]]; then
      tmux -u attach-session -t "$detached_session" || break
    else
      tmux -u new-session || break
    fi
  done
fi
