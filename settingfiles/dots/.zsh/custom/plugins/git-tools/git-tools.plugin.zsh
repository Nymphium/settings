if (( $+commands[git-wt] )); then
  _evalcache git wt --init zsh
fi

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gst='git status'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gd='git diff'
alias gl='git pull'
alias glo='git pull origin'
alias glom='git pull origin master'
alias gcom='git checkout master'
alias gw='git wt'
