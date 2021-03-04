#!/bin/sh

updates=$(pkgs list-upgradable)

count=0
if [ -n "$updates" ]; then
	count=$(echo -e "$updates" | wc -l)
fi

# echo $count
# echo '%{u#bd93f9}%{+u}%{F#bd93f9}'" "'%{F-}'" $count"
[ $count -gt 0 ] &&
	echo '%{F#bd93f9}'" "'%{F-}'" $count" ||
	echo ""

exit 0

# vim: set ft=sh foldmethod=indent ai ts=2 sw=2 tw=79:
