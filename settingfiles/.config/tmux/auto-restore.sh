#!/bin/sh
# Restore the newest tmux-resurrect snapshot, once per tmux server.
#
# Driven by a client-attached hook (see tmux.conf), NOT by a `run-shell -b` in
# the config: at server start the config is sourced before the session exists,
# and those jobs raced badly enough that on a real `tmux` launch neither the
# restore nor the save block ran at all, while the very same config worked when
# sourced by hand. By the time a client attaches, the session and the config
# are both settled.
#
# restore.sh is called by absolute path so this keeps working even when TPM
# fails to source the plugin (also observed).
set -u

log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
log="$log_dir/auto-restore.log"
mkdir -p "$log_dir"
say() { printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$log"; }

# Server-global option: survives config reloads and client re-attaches, dies
# with the server. Exactly one restore attempt per server.
if [ "$(tmux show -gv @auto-restore-done 2>/dev/null)" = "1" ]; then
  exit 0
fi
tmux set -gq @auto-restore-done 1

panes="$(tmux list-panes -a 2>/dev/null | wc -l | tr -d ' ')"
if [ "$panes" != "1" ]; then
  say "skip: server is not pristine (panes=$panes)"
  exit 0
fi

snapshot="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/last"
if [ ! -f "$snapshot" ]; then
  say "skip: no snapshot at $snapshot"
  exit 0
fi

say "restoring $(readlink "$snapshot")"
"$HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh" >>"$log" 2>&1
say "restored (panes=$(tmux list-panes -a 2>/dev/null | wc -l | tr -d ' '))"
