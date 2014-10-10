PANE_NUM=`tmux display -p "#{window_panes}"`

WIN_NUM=`tmux display -p "#{session_windows}"`

if [ ${PANE_NUM} -eq 1 -a ${WIN_NUM} -eq 1 ]; then
	tmux split-window -c $HOME
	tmux 'kill-pane' -t 0
else
	tmux 'kill-pane'
	# echo ${PANE_NUM}
	# echo ${WIN_NUM}
fi
