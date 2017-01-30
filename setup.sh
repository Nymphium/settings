#!/usr/bin/bash

set -eux

THDIR=$PWD/settingfiles
TARGET=$HOME

# set dotfiles
for f in .gitconfig .pryrc .tmux .xmodmap .zshrc; do
	ln -s "${THDIR}/${f}" "${TARGET}/"
done

# install oh-my-zsh unless installed
if [[ ! -a "${TARGET}/.oh-my-zsh/" ]]; then
	git clone https://github.com/robbyrussell/oh-my-zsh "${TARGET}/.oh-my-zsh"/
fi

# asdd my theme
ln -s "${THDIR}/nymphium.zsh-theme" "${TARGET}/.oh-my-zsh/custom/"

# tmux
ln -s "${TARGET}/.tmux/.tmux.conf" "${TARGET}/"

# gtk keybind
mkdir -p "${TARGET}/.theme/" && ln -s "${THDIR}/Vi/" "${TARGET}/.theme/"

# .config
## fontconfig
mkdir -p "${TARGET}/.config/" && ln -s "${THDIR}/.config/fontconfig" "${TARGET}/.config/"

## awesome
mkdir -p "${TARGET}/.config/awesome/" && \
	ln -s ${THDIR}/.config/awesome/{rc,myfuncs,autostart,battery_alert,extkey}.lua "${TARGET}/.config/awesome/" && \
	ln -s ${THDIR}/.config/awesome/.luacheckrc "${TARGET}/.config/awesome/"


