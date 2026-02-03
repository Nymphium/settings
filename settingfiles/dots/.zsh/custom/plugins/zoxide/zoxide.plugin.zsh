if [[ ! (( $+commands[zoxide] )) ]]; then
  return
fi

export ZOXIDE_CMD=cd

_evalcache zoxide init zsh --cmd "$ZOXIDE_CMD"
