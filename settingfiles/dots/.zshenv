# vim:ft=sh

[[ -e "${HOME}/.zshenv.local" ]] && source "${HOME}/.zshenv.local"

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
export MANPAGER="/bin/sh -c \"col -b -x | ${EDITOR} -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
export LANG=${LANG:-en_US.UTF-8}

alias awk=gawk

[[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
[[ -e "${HOME}/.nix-profile/share/nix-direnv/direnvrc" ]] && source "${HOME}/.nix-profile/share/nix-direnv/direnvrc"
