# vim:ft=zsh
# shellcheck shell=zsh

if_have() {
  command -v "${1}" > /dev/null 2>&1
}

if [[ -o login ]] || [[ ! "${ZSH}" ]]; then
  source "${HOME}/.zprofile"
fi

export LANG=${LANG:-en_US.UTF-8}

if ls --color -d / >/dev/null 2>/dev/null; then
  # ls is GNU ls
  alias ls='ls --color'
elif ls -G -d / >/dev/null 2>/dev/null; then
  # ls has a -G option, assume it means to display colors like on FreeBSD
  alias ls='ls -G'
fi

# pipe filter {{{
  alias -g G='| grep'
# }}}

# latex/pdf {{{
  alias platex='platex -kanji=utf8 -halt-on-error'
  alias lualatex='lualatex -halt-on-error'
  alias xelatex='xelatex -halt-on-error'
  alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

# git {{{
  alias gs='echo you mean \`git status\` \?'
  alias ghostscript='=gs'
  alias gpo='git push origin'
  alias gpom='git push origin master'
  alias glo='git pull origin'
  alias glom='git pull origin master'
  alias gcom='git checkout master'
# }}}

alias ps='ps auxfh'
alias ag='ag --hidden -S --stats --ignore=.git'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.cvs --exclude-dir=.hg'
alias C='cat'

EDITOR='nvim'

export EDITOR

MANPAGER="/bin/sh -c \"col -b -x | ${EDITOR} -R -c 'set ft=man nolist nonu noma number nocursorcolumn nocursorline' -\""
export MANPAGER

if_have add_comp_ignores && {
  add_comp_ignores class \
    bcf run.xml
}
# }}}

# interactive shell settings {{{
# no flow control
stty -ixon

if [[ ! "${DISPLAY}" ]]; then
  stty iutf8
fi

# keybind
bindkey '^[e' forward-word
bindkey '^[w' backward-word
bindkey -r '^[l'
# }}}

if_have gh && gh copilot --help > /dev/null 2>&1 && {
  eval "$(gh copilot alias -- zsh)"
}

unset -f if_have
