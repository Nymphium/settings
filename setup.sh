#!/usr/bin/zsh -eux

THDIR=$PWD/settingfiles
TARGET=$HOME

# set dotfiles
for f in ${THDIR}/dots/.*; () {
	local dst; dst="${TARGET}/$(basename "${f}")"
	[[ ! -a "${dst}" ]] && ln -s "${f}" "${dst}"
} || :

# install oh-my-zsh unless installed
() {
	local dst; dst="${TARGET}/.oh-my-zsh"
	[[ ! -a "${dst}" ]] && git clone https://github.com/robbyrussell/oh-my-zsh "${dst}"
} || :

# asdd my theme
() {
	local dst; dst="${TARGET}/.oh-my-zsh/custom/"
	[[ ! -a "${dst}" ]] && ln -s "${THDIR}/nymphium.zsh-theme" "${dst}"
} || :

# gtk keybind
() {
	local dst; dst="${TARGET}/.theme/Vi"
	[[ ! -a "${dst}" ]] && mkdir -p "${TARGET}/.theme/" && ln -s "${THDIR}/Vi/" "${dst}"
} || :

# .config
## fontconfig
() {
	local dst; dst="${TARGET}/.config/fontconfig"
	[[ ! -a "${dst}" ]] && mkdir -p "${TARGET}/.config/" && ln -s "${THDIR}/.config/fontconfig" "${dst}"
} || :

## awesome
() {
	mkdir -p "${TARGET}/.config/awesome/"
	for file in {rc,myfuncs,autostart,battery_alert}.lua .luacheckrc; (){
		local dst; dst="${TARGET}/.config/awesome/${file}"
		[[ ! -a "${dst}" ]] && ln -s "${THDIR}/.config/awesome/${file}"  "${dst}"
	}
} || :

