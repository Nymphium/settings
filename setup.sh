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
THCONFIG="${THDIR}/.config"

migrate() {
	local content; content=$1
	local dstdir; dstdir="${TARGET}/.config/${content}/"
	mkdir -p "${dstdir}"
	local THDIR2; THDIR2="${THCONFIG}/${content}"
	for file in "${THDIR2}"; (){
		basefile="$(basename ${file})"
		local dst; dst="${dstdir}${basefile}"
		[[ ! -a "${dst}" ]] && ln -s "${file}" "${dst}"
	}
}

() {
	for target in $(ls "${THDIR2}"); do
		migrate $target
	done
} || :

# .xinitrc
## it is COPIED
() {
	local dst; dst="${TARGET}/.xinitrc"
	[[ ! -a "${dst}" ]] && cp "${THDIR}/.xinitrc" "${dst}"
} || :

