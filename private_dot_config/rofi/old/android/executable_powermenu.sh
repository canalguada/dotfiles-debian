#!/usr/bin/env bash

rofi_command="rofi -theme android/four.rasi"

#uptime=$(uptime -p | sed -e 's/up //g')

lock() {
	if [ "$XDG_SESSION_DESKTOP" = "i3-gnome" ]; then
		dbus-send --type=method_call \
			--dest=org.gnome.ScreenSaver \
			/org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock
	elif [ "$XDG_SESSION_DESKTOP" = "XFCE" ]; then
		xfce4-screensaver-command --lock
	else
		cmd="~/.config/i3/scripts/lockmore --lock-icon --dpms 5 --nofork -e -f"
		${I3LOCKER:-$cmd}
		#light-locker-command -l
	fi
}

quit() {
	if [[ "$XDG_SESSION_DESKTOP" =~ i3.* ]]; then
		i3-msg exit
	elif [ "$XDG_SESSION_DESKTOP" = "XFCE" ]; then
		xfce4-session-logout --fast --logout
	fi
}

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Variable passed to rofi
#options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"
options="$shutdown\n$reboot\n$lock\n$logout"

#chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 2)"
chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
$shutdown)
	systemctl poweroff
	;;
$reboot)
	systemctl reboot
	;;
$lock)
	lock
	;;
$suspend)
	mpc -q pause
	pactl set-sink-mute @DEFAULT_SINK@ 1
	lock
	systemctl suspend
	;;
$logout)
	quit
	;;
esac

# vim: set ft=sh ai ts=2 sw=2 tw=79:
