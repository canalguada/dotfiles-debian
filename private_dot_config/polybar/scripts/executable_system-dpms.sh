#!/bin/sh

t=0
mem=0

toggle() {
    t=$(((t + 1) % 2))
}
trap "toggle" USR1

while true; do
    if [ $t -eq 1 ]; then
        if [ $t -ne $mem ]; then xset s off -dpms; fi
	echo "OFF"
    else
        if [ $t -ne $mem ]; then xset s on +dpms; fi
	echo "ON"
    fi
    sleep 1 &
    wait
    mem=$t
done
