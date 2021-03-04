#!/bin/sh
for pid in $(pidof polybar); do
  echo "cmd:toggle" >|/tmp/polybar_mqueue.$pid
done
# vim: set ft=sh fdm=indent ts=2 sw=2 tw=79 noet:
