#!/bin/sh
# Periodic tmux-resurrect save loop, one instance per tmux server.
#
# tmux-continuum saves from a hook it appends to the status line, and powerkit
# rebuilds the status line on every recomposition, dropping it — so saving is
# done here instead, independent of rendering. Started from the same
# client-attached hook as auto-restore.sh; the PID lock keeps re-attaches and
# config reloads from stacking loops.
set -u

dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
lock="$dir/.autosave.pid"
mkdir -p "$dir"

# A loop killed together with its server never reaches the cleanup below, so
# the lock routinely outlives it: check that the recorded pid is really a loop,
# not just some process that inherited the number.
if [ -f "$lock" ]; then
  pid="$(cat "$lock" 2>/dev/null)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null &&
    ps -p "$pid" -o command= 2>/dev/null | grep -q 'auto-save\.sh'; then
    exit 0
  fi
fi
echo $$ >"$lock"

while tmux list-sessions >/dev/null 2>&1; do
  sleep 120
  # Never overwrite a real snapshot with a bare server: a lone pane holds no
  # state worth keeping, and saving it would repoint `last` at it — that is how
  # a skipped auto-restore used to destroy the session it failed to load.
  panes="$(tmux list-panes -a 2>/dev/null | wc -l | tr -d ' ')"
  [ "$panes" -gt 1 ] 2>/dev/null || continue
  "$HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh" quiet >/dev/null 2>&1
done

rm -f "$lock"
