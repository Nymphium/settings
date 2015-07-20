SSHARG=$(tmux show-environment | grep "^SSH_CONNECTION")

if [ "${SSHARG}" ]; then
	echo "[#[fg=colour47,bold]SSH from ${SSHARG}" | sed -e "s/SSH_CONNECTION=\(\S\+\).*$/\1#[fg=colour27]] /"
fi

