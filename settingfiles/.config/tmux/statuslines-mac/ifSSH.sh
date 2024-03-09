HAS_SSH=$(tmux showenv SSH_CONNECTION | awk '{ gsub(/.*=/, "", $1); print $1}')

if [[ "${#HAS_SSH}" -gt 2 ]] && [[ ! "${SSHARG}" =~ ^-.* ]]; then
	echo "[#[fg=colour47,bold]SSH from ${HAS_SSH}#[fg=colour27,bold]] "
fi

