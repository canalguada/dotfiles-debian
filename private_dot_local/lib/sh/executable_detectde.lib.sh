#!/bin/sh

DESKTOP=""
DESKTOP_VERSION=""

is_openbox() {
	pgrep -u "$(id -u)" openbox >/dev/null
}
is_metacity() {
	pgrep -u "$(id -u)" metacity >/dev/null
}
is_kwin() {
	pgrep -u "$(id -u)" kwin_x11 >/dev/null
}
is_budgie() {
	pgrep -u "$(id -u)" budgie-panel >/dev/null
}
is_flashback() {
	pgrep -u "$(id -u)" gnome-flashback >/dev/null
}
is_xfce() {
	pgrep -u "$(id -u)" xfce4-session >/dev/null
}


XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-"Unknown"}

case "$XDG_CURRENT_DESKTOP" in
	i3|Enlightenment|XFCE|LXDE)
		DESKTOP=$XDG_CURRENT_DESKTOP ;;
	*)
		# LXQt
		if pgrep -u "$(id -u)" lxqt-session >/dev/null; then
			DESKTOP="LXQt"
			if is_openbox; then
				DESKTOP="${DESKTOP}:Openbox"
			elif is_kwin; then
				DESKTOP="${DESKTOP}:Kwin"
			elif is_metacity; then
				DESKTOP="${DESKTOP}:Metacity"
			else
				DESKTOP="${DESKTOP}:Other"
			fi
		# Budgie
		elif is_budgie; then
			DESKTOP="Budgie"
			if is_openbox; then
				DESKTOP="${DESKTOP}:Openbox"
			else
				DESKTOP="${DESKTOP}:GNOME"
			fi
		# Openbox
		elif is_openbox; then
			if is_flashback; then
				DESKTOP="GNOME:Openbox"
			elif is_kwin; then
				DESKTOP="KDE:Openbox"
			elif is_xfce; then
				DESKTOP="XFCE:Openbox"
			else
				DESKTOP="Openbox"
			fi
		# Metacity
		elif is_metacity; then
			if is_flashback; then
				DESKTOP="GNOME:Metacity"
			fi
		# KDE
		elif [ "$(env | grep KDE_FULL_SESSION | tail -c +18)" = "true" ]; then
			DESKTOP="KDE"
		# Mate / "$XDG_CURRENT_DESKTOP" = "MATE"
		elif pgrep -u "$(id -u)" mate-session >/dev/null; then
			DESKTOP="MATE"
		# Gnome 3 / Yaru
		elif pgrep -u "$(id -u)" gnome-shell >/dev/null; then
			case $XDG_CURRENT_DESKTOP in
				"Yaru:ubuntu:GNOME" ) DESKTOP="Yaru:GNOME" ;;
				* ) DESKTOP="GNOME" ;;
			esac
		# Cinnamon, for cases when it is detectable
		elif [ "$XDG_CURRENT_DESKTOP" = "X-Cinnamon" ]; then
			DESKTOP="Cinnamon"
		# Unity
		elif pgrep -u "$(id -u)" unity-panel > /dev/null; then
			DESKTOP="UNITY"
		else
			DESKTOP="Unknown"
		fi
		;;
esac


_package_version() { pacman -Q "$1" | cut -d" " -f2 | cut -d- -f1; }

case "$DESKTOP" in
	i3)
		DESKTOP_VERSION=$(_package_version i3-gaps)
		;;
	XFCE*)
		DESKTOP_VERSION=$(_package_version xfce4-session)
		;;
	"LXQt:Openbox"|"LXQt:Kwin"|"LXQt:Metacity"|"LXQt:Other")
		DESKTOP_VERSION=$(_package_version lxqt-about)
		;;
	"Budgie:Openbox"|"Budgie:GNOME")
		DESKTOP_VERSION=$(_package_version budgie-desktop)
		[ -z "$DESKTOP_VERSION" ] && \
			DESKTOP_VERSION=$(_package_version budgie-desktop-git)
		;;
	Openbox)
		DESKTOP_VERSION=$(openbox --version | grep Openbox | cut -d' ' -f2)
		;;
	KDE)
		DESKTOP_VERSION=$(plasmashell --version 2>/dev/null | awk '{print $2}')
		;;
	"GNOME"|"Yaru:GNOME")
		DESKTOP_VERSION=$(gnome-shell --version | awk '{print $3}')
		;;
	"GNOME:Openbox"|"GNOME:Metacity")
		DESKTOP_VERSION=$(gnome-shell --version | awk '{print $3}')
		#DESKTOP_VERSION=$(_package_version gnome-flashback)
		;;
	MATE)
		DESKTOP_VERSION=$(mate-about --version | awk '{print $4}')
		;;
	Enlightenment)
		DESKTOP_VERSION=$(_package_version enlightenment)
		;;
	Cinnamon)
		DESKTOP_VERSION=$(cinnamon --version | awk '{print $2}')
		;;
	LXDE)
		DESKTOP_VERSION=$(_package_version lxde-common)
		;;
	UNITY)
		DESKTOP_VERSION=$(unity --version | awk '{print $2}')
		;;
esac

export DESKTOP
export DESKTOP_VERSION

# vim: set ai ts=4 sw=4 tw=79:
