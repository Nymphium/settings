status_line=`lua tmux-statusline.lua`

echo tmux set-option -g status-left ${status_line} | sh
