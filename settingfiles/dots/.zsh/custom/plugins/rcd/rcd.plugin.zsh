# Load custom configurations
RCD=$HOME/.zsh.d
if [[ -d "${RCD}" ]] && [[ -n "$(ls -A "${RCD}")" ]]; then
	for f in "${RCD}"/*;
    do
    # shellcheck disable=1090
    source "${f}"
  done
fi
