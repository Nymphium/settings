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
	local omz; omz="${TARGET}/.oh-my-zsh"
	[[ ! -a "${omz}" ]] && git clone https://github.com/robbyrussell/oh-my-zsh "${omz}"

	# install theme
	local dst; dst="${TARGET}/.oh-my-zsh/custom/themes/"
	[[ ! -d "${dst}" ]] && mkdir -p "${dst}"

	ln -s "${THDIR}/nymphium.zsh-theme" "${dst}"
} || :

# gtk keybind
() {
	local dst; dst="${TARGET}/.themes/Vi"
	[[ ! -a "${dst}" ]] && mkdir -p "${TARGET}/.themes/" && ln -s "${THDIR}/Vi/" "${dst}"
} || :

# bin
(){
	local dst; dst="${TARGET}/bin/"
	mkdir -p "${TARGET}/.local/bin"

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
	local THDIR2; THDIR2="${THDIR}/.config/awesome"
	for file in "${THDIR2}"/*.lua .luacheckrc; (){
		basefile="$(basename ${file})"
		local dst; dst="${TARGET}/.config/awesome/${basefile}"
		[[ ! -a "${dst}" ]] && ln -s "${file}"  "${dst}"
	}
} || :

# .xinitrc
## it is COPIED
() {
	local dst; dst="${TARGET}/.xinitrc"
	[[ ! -a "${dst}" ]] && cp "${THDIR}/.xinitrc" "${dst}"
} || :

