# vim: set filetype=sh foldmethod=indent ai ts=4 sw=4 tw=79:

#shellcheck disable=SC2155

## Common ######################################################

case "$TERM" in
    linux)
        [ -n "$FBTERM" ] && export TERM=fbterm
        ;;
esac

export TMPDIR=/tmp
#export TMPDIR=$HOME/.local/tmp
export TMP=$TMPDIR
export TEMP=$TMPDIR
export TEMPDIR=$TMPDIR

export NVIM_PATH=/usr/bin/nvim
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
# export NVIM_LISTEN_ADDRESS=127.0.0.1:$(($(id -ru) + 7777))

export MYNVIMRC=$HOME/.config/nvim/init.vim
#export VIM_OPTIONS="-p"

export EDITOR=nv
export VISUAL=$EDITOR
export SUDO_EDITOR=$EDITOR

# export LESS_TERMCAP_mb=$'\e[1;32m'
# export LESS_TERMCAP_md=$'\e[1;32m'
# export LESS_TERMCAP_me=$'\e[0m'
# export LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$'\e[01;33m'
# export LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$'\e[1;4;31m'

#Following are the color codes that we used in the above configuration.
#31 – red
#32 – green
#33 – yellow
#And here are the meanings of the escape codes used in the above configuration.
#0 – reset/normal
#1 – bold
#4 – underlined

#export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
#nvim -u NONE -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
#-c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
#-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

export BAT_THEME="Monokai Extended"
export BAT_PAGER="less -RF"
alias bat='batcat'

export LESS="-s -M +Gg"
export PAGER="/usr/bin/less"
# shellcheck disable=SC2139
alias zless="$PAGER"

# Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}
# export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export MANPAGER="less -RF"

# Fzf
export FZF_DEFAULT_OPTS="--extended  --cycle --bind '?:preview:batcat --color=always --style=numbers --line-range=:500 {}'"

export PROJECT_PATHS="$HOME/PycharmProjects:$HOME/Scripts:$HOME/Projects"

#export PYTHONPATH=$PYTHONPATH:/home/canalguada/.local/lib/python/site-packages
export PYTHONDOCS=/usr/share/doc/python/html/


#BUILDROOT="$HOME/builds/openwrt-dg834gt/src/openwrt"
#BUILDROOT_PATH="$BUILDROOT/staging_dir/host/bin"

appendpath() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*) PATH="${PATH:+$PATH:}$1" ;;
	esac
}
prependpath() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*) PATH="$1${PATH:+:$PATH}" ;;
	esac
}

if [ $(id -ru) -ge 1000 ]; then
	## Nodejs
	#VERSION=v10.19.0
	#DISTRO=linux-x86
	#prependpath "/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin"

	## Npm packages
	#export npm_config_prefix="$HOME/.node_modules"
	#NPM_PATH="$HOME/.node_modules/bin"
	#prependpath "$NPM_PATH"

	# Go
	export GOPATH="$HOME/.go"
	GO_PATH="$HOME/.go/bin"
	prependpath "$GO_PATH"

	# Ruby gems
	export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
	GEM_PATH="$GEM_HOME/bin"
	prependpath "$GEM_PATH"

	prependpath "${HOME}/Scripts"

	# Various
	[ -d "${HOME}/bin/appimages" ] && prependpath "${HOME}/bin/appimages"
	#prependpath "${HOME}/.local/opt/relica/bin"
	#prependpath "/var/lib/snapd/snap/bin:$path"
	#appendpath "$BUILDROOT_PATH"
	[ -d "/usr/lib/ccache/bin" ] && prependpath "/usr/lib/ccache/bin/"

	# i3 desktop
	[ -d "${HOME}/.config/rofi/bin" ] && prependpath "${HOME}/.config/rofi/bin"
	for item in "i3" "polybar" "rofi"; do
		[ -d "${HOME}/.config/$item/scripts" ] &&
			prependpath "${HOME}/.config/$item/scripts"
	done

	prependpath "${HOME}/bin"
	prependpath "${HOME}/.local/bin"

	[ -d "${HOME}/bin/nicy" ] && prependpath "${HOME}/bin/nicy"
fi
export PATH
unset appendpath
unset prependpath

export MAKEPKG_CONF=$HOME/.config/makepkg.conf
#export ARCHFLAGS="-arch x86_64"
export CPPFLAGS="-D_FORTIFY_SOURCE=2"
export CFLAGS="-march=native -O2 -pipe -fno-plt"
export CXXFLAGS="-march=native -O2 -pipe -fno-plt"
export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
#export MAKEFLAGS="-j2"

# Restic
#MOUNT_ROOT="/run/media/canalguada"
MOUNT_ROOT="/media/Freebox"
BACKUP_ROOT="${MOUNT_ROOT}/LIVE/Backup"

export RESTIC_REPOSITORY="${BACKUP_ROOT}/restic"
export RESTIC_PASSWORD_COMMAND="/home/canalguada/bin/pass-show restic/live"

export RELICA_REPOSITORY="${BACKUP_ROOT}/relica/relica_destination/backups/default"

export TASKDDATA=/var/lib/taskd
export TASKDSERVER=localhost
export TASKDPORT=53859

#export CHROOT=$HOME/builds/chroot

export GITHUB_USER=$USER
#export GITHUB_PASSWORD=$(pass show "web/github.com/$USER"|head -n1)

DEBEMAIL="guadalupe.david@gmail.com"
DEBFULLNAME="David GUADALUPE"
export DEBEMAIL DEBFULLNAME

## Graphical ###################################################

export MYTERMINAL=urxvt
#export TERMINAL="$HOME/bin/Terminal"
export TERMINAL=x-terminal-emulator
export BROWSER="$HOME/bin/Browser"

export RXVT_SOCKET=/run/user/$(id -ru)/urxvtd-$(hostname)

I3SCRIPTS="${XDG_CONFIG_HOME:-$HOME/.config}/i3/scripts"
LOCKBG="--image-fill $HOME/Images/Backgrounds/default.png"
export I3LOCKER="$I3SCRIPTS/lockmore $LOCKBG --blur --lock-icon --nofork -f -e"
export I3SLIDESHOW="$I3SCRIPTS/slideshow"

export MYBACKGROUNDS="$HOME/Images/Backgrounds/Favorites"

## export JAVA_HOME JDK ##
# export JAVA_HOME="/usr/java/latest"
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dsun.java2d.opengl=true'
export JAVA_FONTS=/usr/share/fonts/TTF
#export MOZ_PLUGIN_PATH=/usr/lib64/mozilla/plugins

export SDL_VIDEO_FULLSCREEN_HEAD=0

export ELINKS_XTERM="urxvtc -e"
export WWW_HOME="https://lite.duckduckgo.com/lite/"

##export LIBVA_DRIVER_NAME=vdpau
#export LIBVA_DRIVER_NAME=radeonsi
#export VDPAU_DRIVER=r600
## VDPAU/VA-GL driver
#export VDPAU_DRIVER=va_gl

export WINEPREFIX=$HOME/.wine
export WINEARCH=win32

# Gtk
export GTK_CSD=1
export GTK2_RC_FILES=$HOME/.gtkrc-2.0

# QT, KDE
#export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_LOGGING_RULES='*=false'
# export QML_DISABLE_DISK_CACH=1
export QML_FORCE_DISK_CACHE=1
export QT_ACCESSIBILITY=0
export QSG_RENDERER_LOOP=basic

# Wayland
export XCURSOR_PATH=$HOME/.icons:/usr/local/share/icons:/usr/share/icons
export XCURSOR_SIZE=24

export EXPORTS=true
