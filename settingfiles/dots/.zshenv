# vim:ft=sh

# nested shells re-run this file; keep PATH free of duplicates
typeset -U path
export path=(
  "${HOME}/bin"
  "${HOME}/local/bin"
  "${HOME}/.local/bin"
  "/opt/homebrew/opt/coreutils/libexec/gnubin"
  "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "${path[@]}"
)

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export path=("${GOBIN}" "${path[@]}")

export EDITOR='nvim'
export MANPAGER='nvim +Man!'
export LANG=${LANG:-en_US.UTF-8}

[[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
[[ -e "${HOME}/.nix-profile/share/nix-direnv/direnvrc" ]] && source "${HOME}/.nix-profile/share/nix-direnv/direnvrc"

[[ -e "${HOME}/.zshenv.local" ]] && source "${HOME}/.zshenv.local"
