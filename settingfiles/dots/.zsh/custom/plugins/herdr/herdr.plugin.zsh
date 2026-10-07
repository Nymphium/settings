(( $+commands[herdr] )) || return

# attach herdr in Ghostty only; panes inside herdr set HERDR_ENV, so they don't nest.
# close the window on a clean exit, drop to a plain shell if herdr fails
if [[ -o interactive && "$TERM_PROGRAM" == ghostty && -z "$HERDR_ENV" ]]; then
  herdr && exit
fi
