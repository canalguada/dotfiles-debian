#!/usr/bin/env bash

rofi_command="rofi -theme android/three.rasi"
image_viewer="eog"

# Options
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -p '' -dmenu -selected-row 1)"
sleep 1
if [ "$XDG_SESSION_DESKTOP" = "i3" ]; then
	scrot_dest='Screenshot_%Y-%m-%d-%S_$wx$h.png'
	scrot_post_cmd='mv $f ~/Images/Screenshots ; '
	scrot_post_cmd+="$image_viewer"' ~/Images/Screenshots/$f'
	cmd=(scrot "$scrot_dest" -e "$scrot_post_cmd")
	case $chosen in
	$screen)
		(
			cd
			"${cmd[@]}"
		)
		;;
	$area)
		(
			cd
			"${cmd[@]}" -s
		)
		;;
	$window)
		(
			cd
			"${cmd[@]}" -u
		)
		;;
	esac
elif [ "$XDG_SESSION_DESKTOP" = "i3-gnome" ]; then
	cmd=(gnome-screenshot -f "Screenshot_$(date +"%Y-%m-%d-%H-%M-%S").png")
	case $chosen in
	$screen)
		"${cmd[@]}"
		;;
	$area)
		"${cmd[@]}" -a
		;;
	$window)
		"${cmd[@]}" -w -B
		;;
	esac
elif pgrep xfce4-session >/dev/null; then
	cmd=(xfce4-screenshooter -o "$image_viewer" -s "$HOME/Images/Screenshots/")
	case $chosen in
	$screen)
		"${cmd[@]}" -f
		;;
	$area)
		"${cmd[@]}" -r
		;;
	$window)
		"${cmd[@]}" -w
		;;
	esac
fi

# vim: set ft=sh ai ts=4 sw=4 tw=79:
