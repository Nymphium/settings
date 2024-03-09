HAS_SSH=$(tmux showenv SSH_CONNECTION 2> /dev/null | sed -e 's/SSH_CONNECTION=\(\S\+\).*$/\1/')

if [[ ${#HAS_SSH} -gt 2 ]] && ! [[ "${HAS_SSH}" =~ 'SSH_CONNECTION' ]]; then
	echo "[#[fg=colour47,bold]SSH from ${HAS_SSH}#[fg=colour27,bold]] "
fi

