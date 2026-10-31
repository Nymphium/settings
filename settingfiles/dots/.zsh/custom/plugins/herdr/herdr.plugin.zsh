(( $+commands[herdr] )) || return

# panes inside herdr set HERDR_ENV, so they don't nest.
# close the window on a clean exit, drop to a plain shell if herdr fails
if [[ -o interactive && -z "$HERDR_ENV" ]]; then
  herdr && exit
fi
