#!/usr/bin/env bash

rofi_command="rofi -theme android/three.rasi"
#rofi_command="rofi"
#rofi_command=" -theme android/six.rasi"
#rofi_command+=" -theme-str '#listview { lines:3; };'"

active=""
urgent=""

VOLUME_STATUS=$(pavolume status)
MUTED=${VOLUME_STATUS%% *}
CURVOL=${VOLUME_STATUS##* }

if [[ $MUTED == "no" ]]; then
	active="-a 1"
else
	urgent="-u 1"
fi

if [[ $MUTED == "yes" ]]; then
	VOLUME="${CURVOL}%"
else
	VOLUME="Mu..."
fi

## Icons
ICON_UP=""
ICON_DOWN=""
ICON_MUTED=""

options="$ICON_UP\n$ICON_MUTED\n$ICON_DOWN"

## Main
chosen="$(echo -e "$options" | $rofi_command -p "$VOLUME" -dmenu \
								$active $urgent -selected-row 0)"

case $chosen in
	$ICON_UP)
		pavolume up
		;;
	$ICON_DOWN)
		pavolume down
		;;
	$ICON_MUTED)
		pavolume mute
		;;
esac

# vim: set foldmethod=indent ai ts=4 sw=4 tw=79:
