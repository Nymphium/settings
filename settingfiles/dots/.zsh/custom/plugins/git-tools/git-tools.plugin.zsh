if (( $+commands[git-wt] )); then
  _evalcache git wt --init zsh
fi

alias gs='echo you mean `git status` ?'
alias ghostscript='=gs'
alias gpo='git push origin'
alias gpom='git push origin master'
alias glo='git pull origin'
alias glom='git pull origin master'
alias gcom='git checkout master'
alias gw='git wt'
