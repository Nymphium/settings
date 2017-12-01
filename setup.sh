#!/bin/zsh -ux

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

# add my theme
() {
	local dst; dst="${TARGET}/.oh-my-zsh/custom/themes/"
	[[ ! -a "${dst}" ]] && mkdir -p "${dst}" && ln -s "${THDIR}/nymphium.zsh-theme" "${dst}"
} || :

# gtk keybind
() {
	local dst; dst="${TARGET}/.themes/Vi"
	[[ ! -a "${dst}" ]] && mkdir -p "${TARGET}/.themes/" && ln -s "${THDIR}/Vi/" "${dst}"
} || :

# bin
(){
	local dst; dst="${TARGET}/bin/"
	if [[ ! -a "${dst}" ]]; then
		mkdir -p "${dst}"
	fi
	ln -s "${THDIR}/bin/"* "${dst}"
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
	for file in {rc,myfuncs,autostart,battery_alert,shortcuts}.lua .luacheckrc; (){
		local dst; dst="${TARGET}/.config/awesome/${file}"
		[[ ! -a "${dst}" ]] && ln -s "${THDIR}/.config/awesome/${file}"  "${dst}"
	}
} || :

# .xinitrc
## it is COPIED
() {
	local dst; dst="${TARGET}/.xinitrc"
	[[ ! -a "${dst}" ]] && cp "${THDIR}/.xinitrc" "${dst}"
} || :

