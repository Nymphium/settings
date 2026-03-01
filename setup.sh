#!/usr/bin/env zsh

# ==============================================================================
# Setup Script for Dotfiles
# ==============================================================================
# Refactored for readability, error handling, modularity, and idempotency.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Constants & Configuration
# ------------------------------------------------------------------------------

readonly REPO_ROOT="${0:a:h}"
readonly SETTING_FILES="${REPO_ROOT}/settingfiles"
readonly TARGET_DIR="${HOME}"
readonly XDG_CONFIG_HOME="${TARGET_DIR}/.config"
readonly BIN_DIR="${TARGET_DIR}/bin"

# Colors for logging
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------

log_info() {
  printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
  printf "${GREEN}[OK]${NC} %s\n" "$1"
}

log_warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

is_linux() {
  [[ "$(uname -s)" == "Linux" ]]
}

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    log_info "Created directory: $dir"
  fi
}

# Creates a symbolic link.
# Usage: link_file "source_path" "target_path"
link_file() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    log_warn "Source file not found, skipping: $src"
    return
  fi

  # Create parent directory if it doesn't exist
  ensure_dir "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    # Check if it points to the correct location
    local current_target
    current_target=$(readlink "$dst")
    if [[ "$current_target" == "$src" ]]; then
      # log_info "Already linked: $dst -> $src"
      return
    fi
    log_warn "Updating link: $dst -> $src (was $current_target)"
  elif [[ -e "$dst" ]]; then
    log_warn "File exists and is not a symlink: $dst. Backing up..."
    mv "$dst" "${dst}.bak.$(date +%s)"
  fi

  ln -sf "$src" "$dst"
  log_success "Linked: $dst -> $src"
}

# Copies a file.
# Usage: copy_file "source_path" "target_path"
copy_file() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    log_warn "Source file not found, skipping: $src"
    return
  fi

  ensure_dir "$(dirname "$dst")"

  if [[ -e "$dst" ]]; then
    # Simple check to avoid unnecessary copies (could use cmp)
    if cmp -s "$src" "$dst"; then
      return
    fi
    log_warn "Overwriting file: $dst"
  fi

  cp "$src" "$dst"
  log_success "Copied: $dst"
}

# ------------------------------------------------------------------------------
# Core Modules
# ------------------------------------------------------------------------------

setup_antidote() {
  log_info "Setting up Antidote..."
  local antidote_dir="${TARGET_DIR}/.antidote"
  
  if [[ ! -d "$antidote_dir" ]]; then
    log_info "Cloning Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
  else
    log_info "Antidote already installed."
  fi

  local custom_dst="${antidote_dir}/custom"
  local custom_src="${SETTING_FILES}/dots/.antidote/custom"

  # Link themes and plugins
  for type in themes plugins; do
    if [[ -d "${custom_src}/${type}" ]]; then
      for f in "${custom_src}/${type}"/*; do
        link_file "$f" "${custom_dst}/${type}/$(basename "$f")"
      done
    fi
  done
}

setup_gtk() {
  if ! is_linux; then return; fi
  log_info "Setting up GTK (Linux)..."
  
  local vi_theme_src="${SETTING_FILES}/Vi"
  local themes_dir="${TARGET_DIR}/.themes"
  
  link_file "$vi_theme_src" "${themes_dir}/Vi"
}

setup_binaries() {
  log_info "Setting up binaries..."
  local src_bin="${SETTING_FILES}/bin"
  local dst_bin="${TARGET_DIR}/bin" # User's ~/bin

  ensure_dir "${TARGET_DIR}/.local/bin" # Kept from original script
  
  if [[ -d "$src_bin" ]]; then
    for f in "$src_bin"/*; do
      link_file "$f" "${dst_bin}/$(basename "$f")"
    done
  fi
}

setup_terminfo() {
  if ! is_macos; then return; fi
  log_info "Setting up Terminfo (macOS)..."

  if ! command -v tic &>/dev/null; then
    log_warn "tic command not found, skipping terminfo setup."
    return
  fi

  # Check if we need to install (naive check)
  # This part involves network and compilation, so we might want to skip if already done.
  # For now, I'll wrap it in a conditional or try/catch.
  
  # Using a subshell to avoid changing directory for main script
  (
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1
    
    log_info "Downloading terminfo..."
    if curl -fLO https://invisible-island.net/datafiles/current/terminfo.src.gz; then
      gunzip terminfo.src.gz
      log_info "Compiling terminfo for tmux-256color..."
      /usr/bin/tic -xe tmux-256color terminfo.src || log_warn "tic compilation failed."
    else
      log_warn "Failed to download terminfo."
    fi
    rm -rf "$temp_dir"
  ) || log_error "Terminfo setup failed."
}

setup_configs() {
  log_info "Setting up configurations in .config..."
  
  local config_src="${SETTING_FILES}/.config"
  
  if [[ ! -d "$config_src" ]]; then
    log_warn "No .config directory found in settingfiles."
    return
  fi

  for config in "$config_src"/*; do
    local name
    name=$(basename "$config")

    # Special handling for Karabiner
    if [[ "$name" == "karabiner" ]]; then
      setup_karabiner
      continue
    fi

    # Default: Link the directory
    link_file "$config" "${XDG_CONFIG_HOME}/${name}"
  done
}

setup_karabiner() {
  log_info "Setting up Karabiner..."
  local src="${SETTING_FILES}/.config/karabiner"
  local dst="${XDG_CONFIG_HOME}/karabiner"

  ensure_dir "${dst}"
  ensure_dir "${dst}/assets/complex_modifications"

  # Link complex modifications if they exist in source
  # Original script only created the dir. I assume we want to link assets if present?
  # Original script: mkdir .../complex_modifications/ (and that's it?)
  # But later it did `migrate`, which might have tried to link things.
  # Looking at file tree: settingfiles/.config/karabiner/assets/complex_modifications/macos.json
  # So we probably want to link the `assets` folder or subfolders.

  # Strategy: Link `assets` folder if possible, otherwise link subfiles.
  # To be safe and follow the "copy json" pattern:

  # 1. Copy karabiner.json
  copy_file "${src}/karabiner.json" "${dst}/karabiner.json"

  # 2. Link assets directory (simpler than deep linking)
  link_file "${src}/assets" "${dst}/assets"
}

setup_dotfiles() {
  log_info "Setting up dotfiles..."
  local dots_src="${SETTING_FILES}/dots"

  if [[ -d "$dots_src" ]]; then
    # Enable dotglob to match hidden files
    setopt local_options dotglob
    for f in "$dots_src"/*; do
      local name
      name=$(basename "$f")
      # Skip . and ..
      if [[ "$name" == "." || "$name" == ".." ]]; then continue; fi

      link_file "$f" "${TARGET_DIR}/${name}"
    done
  fi
}

setup_tmux() {
  log_info "Setting up Tmux Plugin Manager (tpm)..."
  local tpm_dir="${TARGET_DIR}/.tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    log_info "Cloning tpm..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    log_info "tpm already installed."
  fi
}

setup_xinitrc() {
  log_info "Setting up .xinitrc..."
  # Original script copied it.
  copy_file "${SETTING_FILES}/.xinitrc" "${TARGET_DIR}/.xinitrc"
}

# ------------------------------------------------------------------------------
# Main Execution
# ------------------------------------------------------------------------------

main() {
  log_info "Starting setup..."
  log_info "OS: $(uname -s)"
  log_info "Repo Root: ${REPO_ROOT}"

  setup_antidote
  setup_gtk
  setup_binaries
  setup_configs
  setup_dotfiles
  setup_tmux
  setup_xinitrc
  setup_terminfo

  log_success "Setup complete!"
}

main "$@"
