if (( $+commands[git-wt] )); then
  _evalcache git wt --init zsh
fi

# origin's default branch (main/master/...), falling back to master
_git_default_branch() {
  local b
  b=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null) || b=origin/master
  print -r -- "${b#origin/}"
}

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gst='git status'
alias gpo='git push origin'
alias gpom='git push origin "$(_git_default_branch)"'
alias gd='git diff'
alias gl='git pull'
alias glo='git pull origin'
alias glom='git pull origin "$(_git_default_branch)"'
alias gcom='git checkout "$(_git_default_branch)"'
alias gw='git wt'
