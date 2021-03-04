#!/bin/sh
# vim: set ft=sh fdm=indent ai ts=2 sw=2 tw=79 noet:

# if [ $(systemctl --user is-active mpd.socket) = "active" ]; then
#   if test ! pgrep -fax "python3 /usr/bin/mpDris2.*" >/dev/null 2>&1; then
#     i3-msg 'exec mpDris2 --music-dir=~/smbnet/freebox_server/ntfs/Musique'
#   fi
# fi

case "$XDG_SESSION_DESKTOP" in
	i3)
		i3-msg 'exec --no-startup-id exec systemctl --user start --no-block i3-session.target'

		I3SCRIPTS="${XDG_CONFIG_HOME:-$HOME/.config}/i3/scripts"
		I3LOCKER=${I3LOCKER:-"$I3SCRIPTS/lockmore --blur --lock-icon --nofork -f -e"}
		# I3LOCKER="light-locker-command -l"
		# msg="light-locker --no-lock-on-lid --no-idle-hint"
		# i3-msg "exec --no-startup-id $msg"
		I3SLIDESHOW=${I3SLIDESHOW:-"$I3SCRIPTS/slideshow"}

		# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
		# screen before suspend. Use loginctl lock-session to lock your screen.
		msg="xss-lock --transfer-sleep-lock -n $I3SLIDESHOW -- $I3LOCKER"
		# i3-msg "exec --no-startup-id exec $msg"
		;;
	i3-gnome)
		# i3-msg 'exec dunst'
		# i3-msg 'exec --no-startup-id gnome-flashback'
		# i3-msg 'exec --no-startup-id gnome-power-manager'

		# I3LOCKER="dbus-send --type=method_call --dest=org.gnome.ScreenSaver "
		# I3LOCKER+="/org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock"
		# export I3LOCKER
		;;
esac

