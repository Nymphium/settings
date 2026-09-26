# Load custom configurations
() {
  local f
  for f in $HOME/.zsh.d/*(N); do
    source "$f"
  done
}
