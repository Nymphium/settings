#!/bin/zsh -ux

THDIR=$PWD/settingfiles
TARGET=$HOME

() {
	local dst; dst="/etc/acpi/events/LIDCLOSE_EVENT";
	[[ ! -a "${dst}" ]] && cat <<-EOL > "${dst}"
event=button/lid LID close
action=${THDIR}/bin/lidlock.sh
	EOL
}

