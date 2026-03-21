#!/usr/bin/env bash
# Show local (server) IP when this machine is being SSH'd into.
# Verify sshd is actually our ancestor, not just stale env vars.
pid=$$
while [[ "$pid" -gt 1 ]]; do
  cmd=$(ps -o comm= -p "$pid" 2>/dev/null) || break
  if [[ "$cmd" == sshd ]]; then
    # SSH_CONNECTION: client_ip client_port server_ip server_port
    if [[ -n "${SSH_CONNECTION:-}" ]]; then
      ip=$(awk '{print $3}' <<< "$SSH_CONNECTION")
      printf '󰣇 %s ' "$ip"
    fi
    exit 0
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ') || break
done
