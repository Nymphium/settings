#!/bin/zsh -u

THDIR=$PWD/settingfiles
TARGET=$HOME

if_darwin() {
	[[ $(uname -s) = "Darwin" ]]
}

if_linux() {
	[[ $(uname -s) = "Linux" ]]
}

# set dotfiles
for f in ${THDIR}/dots/.*; () {
	local dst; dst="${TARGET}/$(basename "${f}")"
	[[ ! -a "${dst}" ]] && ln -s "${f}" "${dst}"
} || :

# install oh-my-zsh unless installed
() {
	local omz; omz="${TARGET}/.oh-my-zsh"
	[[ ! -a "${omz}" ]] && git clone https://github.com/robbyrussell/oh-my-zsh "${omz}"

	local dst; dst="${TARGET}/.oh-my-zsh/custom/"
	local src; src="${THDIR}/dots/.oh-my-zsh/custom/"

	for tgt in themes plugins; () {
		for f in "${src}${tgt}"/*; () {
			[[ ! -a "${dst}${tgt}/$(basename "${f}")" ]] && ln -s "${f}" "${dst}${tgt}/"
		}
	}
} || :

# gtk keybind
() {
	if_linux && {
		local dst; dst="${TARGET}/.themes/Vi"
		[[ ! -a "${dst}" ]] && mkdir -p "${TARGET}/.themes/" && ln -s "${THDIR}/Vi/" "${dst}"
	}
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

() {
	if_darwin && {
		curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
		/usr/bin/tic -xe tmux-256color terminfo.src
	}
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
	for target in $(ls "${THDIR}"); do
		migrate $target
	done

	# karabiner
	rm -rf "${TARGET}/.config/karabiner/karabiner.json"
	cp "${THCONFIG}/karabiner/karabiner.json" "${TARGET}/.config/karabiner/karabiner.json"
} || :


# .xinitrc
## it is COPIED
() {
	local dst; dst="${TARGET}/.xinitrc"
	[[ ! -a "${dst}" ]] && cp "${THDIR}/.xinitrc" "${dst}"
} || :

