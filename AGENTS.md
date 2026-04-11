# Dotfiles Repository

Personal dotfiles and configuration management for macOS/Linux environments.

## Structure

- `settingfiles/` — config files symlinked to `$HOME` via `setup.sh`
  - `.config/` — XDG config (tmux, git, alacritty, wezterm, karabiner, starship, awesome, fontconfig)
  - `bin/` — user scripts
- `setup.sh` — idempotent installer (zsh, non-interactive)
- `setup_sudo.sh` — privileged setup
- `rulesync.jsonc` — rulesync config (Claude Code global sync)

## Principles

- **Idempotency**: all setup scripts must be safe to re-run
- **Symlink, don't copy**: `setup.sh` creates symlinks from `settingfiles/` to `$HOME`
- **No secrets in repo**: credentials, tokens, API keys must never be committed
- **Shell**: zsh is the primary shell; scripts use `#!/usr/bin/env zsh` with `set -euo pipefail`

## When editing configs

- Test changes locally before committing
- Preserve existing structure; don't reorganize without reason
- Commit messages follow conventional commits (e.g., `feat(zsh):`, `fix(tmux):`)
