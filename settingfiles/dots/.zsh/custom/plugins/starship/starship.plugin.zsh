# Starship Theme Setup

if [[ ! (( $+commands[starship] )) ]]; then
  return
fi

_evalcache starship init zsh
export STARSHIP_CACHE=~/.starship/cache
mkdir -p "$STARSHIP_CACHE"

# Dynamic Theme Switching (macOS)
if [[ "$(uname)" == "Darwin" ]]; then
  _update_starship_theme() {
    # Check if feature is enabled (Default: true)
    zstyle -T ':prompt:starship:mac' auto-mode || return

    local mode
    local current_mode_file="${STARSHIP_CACHE}/mode"
    local effective_config="${STARSHIP_CACHE}/effective.toml"

    # Detect Mode
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      mode="dark_mode"
    else
      mode="light_mode"
    fi

    # Only regenerate if mode changed, config missing, or starship.toml updated
    if [[ ! -f "$effective_config" ]] || [[ "$mode" != "$(cat "$current_mode_file" 2>/dev/null)" ]] || [[ "${HOME}/.config/starship.toml" -nt "$effective_config" ]]; then
      # Ensure config exists before trying to read it
      if [[ -f "${HOME}/.config/starship.toml" ]]; then
        echo "palette = \"$mode\"" > "$effective_config"
        cat "${HOME}/.config/starship.toml" >> "$effective_config"
        echo "$mode" > "$current_mode_file"
      fi
    fi
    
    export STARSHIP_CONFIG="$effective_config"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _update_starship_theme
fi
