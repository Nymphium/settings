pane_num=$(tmux display -p "#{window_panes}")
win_num=$(tmux display -p "#{session_windows}")

if [[ "$((pane_num * win_num))" -eq 1 ]]; then
	tmux split-window -c "${HOME}"

	tmux 'kill-pane' -t 0
else
	tmux 'kill-pane'
fi

