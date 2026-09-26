#!/usr/bin/env bash
# Show the server IP when the session was last attached over SSH.
# #() jobs run with the server's global environment, so read the session's
# copy instead: update-environment refreshes SSH_CONNECTION on every attach
# and marks it removed (-SSH_CONNECTION) for a local client.
# SSH_CONNECTION: client_ip client_port server_ip server_port
v="$(tmux show-environment -t "$1" SSH_CONNECTION 2>/dev/null)" || exit 0
case "$v" in SSH_CONNECTION=*) ;; *) exit 0 ;; esac
set -- ${v#SSH_CONNECTION=}
printf '󰣇 %s ' "$3"
