#!/bin/bash

pane_num=$(tmux display -p "#{window_panes}")

win_num=$(tmux display -p "#{session_windows}")

if [ "${win_num}" -gt 1 ] | [ "${pane_num}" -gt 1 ]; then
	tmux kill-pane
else
	tmux split-window -c $HOME

	tmux kill-pane -t 0
fi

