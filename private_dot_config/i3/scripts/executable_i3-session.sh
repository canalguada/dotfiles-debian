#!/bin/sh
# vim: set ft=sh fdm=indent ai ts=2 sw=2 tw=79 noet:

# if [ $(systemctl --user is-active mpd.socket) = "active" ]; then
#   if test ! pgrep -fax "python3 /usr/bin/mpDris2.*" >/dev/null 2>&1; then
#     i3-msg 'exec mpDris2 --music-dir=~/smbnet/freebox_server/ntfs/Musique'
#   fi
# fi

mkdir -p /tmp/$USER/i3/cache

grep -oP "set [$]ws[[:digit:]]+.*" ${XDG_CONFIG_HOME:-$HOME/.config}/i3/config \
	|sed 's/set \$\([^[:blank:]]*\)[[:blank:]]*\(.*\)/\1=\2/g' > /tmp/$USER/i3/cache/workspaces

systemctl --user import-environment

printenv > ~/i3.env

case "$XDG_CURRENT_DESKTOP" in
	i3)
		# systemctl --user start --no-block picom.service
		systemctl --user start --no-block i3-cycle-focus.service
		systemctl --user start --no-block xsettingsd.service
		systemctl --user start --no-block polybar@top.service
		systemctl --user start --no-block polybar@bottom.service
		systemctl --user start --no-block policykit-agent.service
		systemctl --user start --no-block i3-session.target
		# i3-msg 'exec --no-startup-id exec systemctl --user start --no-block i3-session.target'

		# I3SCRIPTS="${XDG_CONFIG_HOME:-$HOME/.config}/i3/scripts"
		# I3LOCKER=${I3LOCKER:-"$I3SCRIPTS/lockmore --blur --lock-icon --nofork -f -e"}
		# # I3LOCKER="light-locker-command -l"
		# # msg="light-locker --no-lock-on-lid --no-idle-hint"
		# # i3-msg "exec --no-startup-id $msg"
		# I3SLIDESHOW=${I3SLIDESHOW:-"$I3SCRIPTS/slideshow"}
    #
		# # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
		# # screen before suspend. Use loginctl lock-session to lock your screen.
		# msg="xss-lock --transfer-sleep-lock -n $I3SLIDESHOW -- $I3LOCKER"
		# # i3-msg "exec --no-startup-id exec $msg"
		;;
	LXQt)
		systemctl --user start --no-block polybar@top.service
		systemctl --user start --no-block polybar@bottom.service
		systemctl --user start --no-block xsettingsd.service
		systemctl --user start --no-block i3-wm.target
		;;
	KDE)
		# i3-msg 'bindsym Mod1+F1 exec xdotool mousemove --sync 27 749 click 1 mousemove restore'
		# i3-msg 'bindsym Mod1+F2 exec --no-startup-id exec gmrun'
		systemctl --user start --no-block i3-wm.target
		;;
	*)
		systemctl --user start --no-block i3-wm.target
		;;
	# i3-gnome)
		# i3-msg 'exec dunst'
		# i3-msg 'exec --no-startup-id gnome-flashback'
		# i3-msg 'exec --no-startup-id gnome-power-manager'

		# I3LOCKER="dbus-send --type=method_call --dest=org.gnome.ScreenSaver "
		# I3LOCKER+="/org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock"
		# export I3LOCKER
		# ;;
esac

