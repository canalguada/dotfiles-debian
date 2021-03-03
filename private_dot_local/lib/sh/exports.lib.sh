# vim: set filetype=sh foldmethod=indent ai ts=4 sw=4 tw=79:

#shellcheck disable=SC2155

export MYTERMINAL=urxvt
#export TERMINAL="$HOME/bin/Terminal"
export TERMINAL=x-terminal-emulator
export BROWSER="$HOME/bin/Browser"

#export TMPDIR=$HOME/.local/tmp
export TMPDIR=/tmp
export TMP=$TMPDIR
export TEMP=$TMPDIR
export TEMPDIR=$TMPDIR

#export TERM=rxvt-unicode
#export TERMINFO=/usr/share/terminfo/r/rxvt-256color
#export COLORTERM=rxvt
#export URXVT_PERL_LIB=
export RXVT_SOCKET=/run/user/$(id -ru)/urxvtd-$(hostname)

export NVIM_LISTEN_ADDRESS=127.0.0.1:$(($(id -ru) + 7777))

I3SCRIPTS="${XDG_CONFIG_HOME:-$HOME/.config}/i3/scripts"
LOCKBG="--image-fill $HOME/Images/Backgrounds/default.png"
export I3LOCKER="$I3SCRIPTS/lockmore $LOCKBG --blur --lock-icon  --nofork -f -e"
export I3SLIDESHOW="$I3SCRIPTS/slideshow"

export MYBACKGROUNDS="$HOME/Images/Backgrounds/Favorites"

# Setup:
#
#  1. Create a directory to hold the virtual environments.
#     (mkdir $HOME/.virtualenvs).
#  2. Add a line like "export WORKON_HOME=$HOME/.virtualenvs"
#     to your .bashrc.
#  3. Add a line like "source /path/to/this/file/virtualenvwrapper.sh"
#     to your .bashrc.
#  4. Run: source ~/.bashrc
#  5. Run: workon
#  6. A list of environments, empty, is printed.
#  7. Run: mkvirtualenv temp
#  8. Run: workon
#  9. This time, the "temp" environment is included.
# 10. Run: workon temp
# 11. The virtual environment is activated.
#
#export WORKON_HOME=~/.virtualenvs
# shellcheck disable=SC1090
#source ~/.local/bin/virtualenvwrapper.sh

## export JAVA_HOME JDK ##
# export JAVA_HOME="/usr/java/latest"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dsun.java2d.opengl=true'
export JAVA_FONTS=/usr/share/fonts/TTF
#export MOZ_PLUGIN_PATH=/usr/lib64/mozilla/plugins

export MYNVIMRC=$HOME/.config/nvim/init.vim
#export VIM_OPTIONS="-p"

export EDITOR="nvim -u NONE"
export VISUAL=$EDITOR
export SUDO_EDITOR=$EDITOR

export ELINKS_XTERM="urxvtc -e"
#export SAL_USE_VCLPLUGIN=kde4

##export LIBVA_DRIVER_NAME=vdpau
#export LIBVA_DRIVER_NAME=radeonsi
#export VDPAU_DRIVER=r600
## VDPAU/VA-GL driver
#export VDPAU_DRIVER=va_gl

# uniquement si installé
# Pepper Flash and Chromium
## Avec Chromium-Pepper-Flash
#export PEPPER_FLASH_VERSION=$(grep '"version":' /usr/lib/PepperFlash/manifest.json| grep -Po '(?<=version": ")(?:\d|\.)*')
#export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp/cache --disk-cache-size=50000000 --ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=$PEPPER_FLASH_VERSION"
## Avec Chrome
#export PEPPER_FLASH_VERSION=$(grep '"version":' /opt/google/chrome/PepperFlash/manifest.json| grep -Po '(?<=version": ")(?:\d|\.)*')
#export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp/cache --disk-cache-size=50000000 --ppapi-flash-path=/opt/google/chrome/PepperFlash/libpepflashplayer.so --ppapi-flash-version=$PEPPER_FLASH_VERSION"

#export PYTHONPATH=$PYTHONPATH:/home/canalguada/.local/lib/python/site-packages
export PYTHONDOCS=/usr/share/doc/python/html/

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

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

# Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

export PAGER="/usr/bin/less"
# shellcheck disable=SC2139
alias zless="$PAGER"

export SDL_VIDEO_FULLSCREEN_HEAD=0

export PROJECT_PATHS="$HOME/PycharmProjects:$HOME/Scripts:$HOME/Projects"


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

export WINEPREFIX=$HOME/.wine
export WINEARCH=win32

export QML_DISABLE_DISK_CACHE=1

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

# export GITHUB_TOKEN=b3058b356eded6b1c640ea067968c3e298aaa965
export GITHUB_USER=canalguada
export GITHUB_PASSWORD="WDBMek]_Mp>-)$>=Y@6bT=hQ>"

