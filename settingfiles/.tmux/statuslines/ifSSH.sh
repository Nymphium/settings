IF_SSH=$(tmux display -p '#S')

if [ ${#IF_SSH} -gt 3 ]; then
	echo "[#[fg=colour47,bold]SSH from $IF_SSH#[fg=colour27]]" | sed -e "s/-/./g"
fi
