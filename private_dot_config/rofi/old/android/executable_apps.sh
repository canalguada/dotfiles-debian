#!/usr/bin/env bash

#grep -oP "set [$]ws[[:digit:]]+.*" ~/.config/i3/config \
	#|sed 's/set \$\([^[:blank:]]*\)[[:blank:]]*\(.*\)/\1=\2/g'
ws1="1:"
ws2="2:"
ws3="3:"
ws4="4:"
ws5="5:"
ws6="6:"
ws7="7:"
ws8="8:"
ws9="9:"
ws10="10:"

jq_filter=".[] | { name: .name, focused: .focused } "
jq_filter+="| select(.focused == true) | .name"
focused_ws=$(i3-msg -t get_workspaces | jq "$jq_filter")
focused_ws=$(eval echo $focused_ws)

echo $focused_ws

i3-wrapper() {
	ws="$1"
	shift
	msg=""
	[ "$ws" != "$focused_ws" ] && msg+='workspace "'$ws'"; '
	msg+="exec $(shell-quote "$@")"
	i3-msg "$msg"
}

rofi_command="rofi -theme android/six.rasi"

# Links
terminal=""
files=""
editor=""
browser=""
music=""
settings=""
mail=""
htop=""
pikaur=""
pcmanfm=""

# Variable passed to rofi
#options="$terminal\n$files\n$editor\n$browser\n$music\n$settings"
options="$(
	cat <<EOF
$browser
$files
$editor
$music
$mail
$htop
$pcmanfm
$terminal
$pikaur
$settings
EOF
)"

chosen="$(echo -e "$options" | $rofi_command -p "Most Used" -dmenu -selected-row 0)"
case $chosen in
$terminal) i3-wrapper "$ws1" Terminal ;;
$files) i3-wrapper "$ws3" FileManager ;;
$editor) i3-wrapper "$ws4" Editor ;;
$browser) i3-wrapper "$ws2" Browser ;;
$music) i3-wrapper "$ws9" Music ;;
$mail) i3-wrapper "$ws5" Mail ;;
$pcmanfm) i3-wrapper "$ws3" pcmanfm-qt ;;
$htop) i3-wrapper "$ws1" SysMon ;;
$pikaur) i3-wrapper "$ws1" SysUpdate ;;
$settings)
	if [ "$XDG_SESSION_DESKTOP" = "i3-gnome" ]; then
		i3-wrapper "$ws6" gnome-control-center
	else
		i3-wrapper "$ws4" Editor -- -p ~/.config/i3/config
	fi

	;;
esac

# vim: set ft=sh ai ts=4 sw=4 tw=79:
