#!/usr/bin/env bash


available="i3_runner:i3_simplemenu:"

style=$(basename "$0")
style=${style%%.sh}
style=${style##rofi_}

case ":$available:" in
	*:${style%%_categories}:*)
		;;
	*)
		style="i3_runner"
		;;
esac

rofi -no-lazy-grab -show drun -theme launchers/"$style".rasi "$@"

# vim: set foldmethod=indent ai ts=4 sw=4 tw=79:
