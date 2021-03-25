# vim: set filetype=sh foldmethod=indent ai ts=4 sw=4 tw=79:

unset fn_exists >/dev/null 2>&1
fn_exists() {
	case "$(LC_ALL=C type "$1" 2>&1)" in
		*"shell function"*) return 0 ;;
		*) return 1 ;;
	esac
	# LC_ALL=C type "$1" 2>&1 | grep -q 'function'
}

## Proxy
MY_HTTP_PROXY="http://localhost:8123/"
MY_HTTPS_PROXY=$MY_HTTP_PROXY
MY_NO_PROXY="localhost,127.0.0.1"
if ! fn_exists disable-proxy; then
	disable_proxy() {
		unset http_proxy
		unset https_proxy
		unset HTTP_PROXY
		unset HTTPS_PROXY
		unset ALL_PROXY
		unset no_proxy
		unset NO_PROXY
		#echo "Disabled proxy environment variables"

		# if command -v npm >/dev/null 2>&1; then
		#     npm config delete proxy
		#     npm config delete https-proxy
		#     #echo "Disabled npm proxy settings"
		# fi
		if command -v git >/dev/null 2>&1; then
			git config --global --unset-all http.proxy
			git config --global --unset-all https.proxy
			#echo "Disabled global Git proxy settings"
		fi
	}
fi
if ! fn_exists enable-proxy; then
	enable_proxy() {
		export http_proxy=$MY_HTTP_PROXY
		export https_proxy=$MY_HTTPS_PROXY
		export HTTP_PROXY=$http_proxy
		export HTTPS_PROXY=$https_proxy
		export ALL_PROXY=$http_proxy
		export no_proxy=$MY_NO_PROXY
		export NO_PROXY=$no_proxy
		#echo "Enabled proxy environment variables"

		# if command -v npm >/dev/null 2>&1; then
		#     npm config set proxy $MY_HTTP_PROXY
		#     npm config set https-proxy $MY_HTTPS_PROXY
		#     #echo "Enabled npm proxy settings"
		# fi
		if command -v git >/dev/null 2>&1; then
			git-global-disable-proxy

			git config --global --add http.proxy $MY_HTTP_PROXY
			git config --global --add https.proxy $MY_HTTPS_PROXY
			#echo "Enabled global Git proxy settings"
		fi
	}
fi
# }}}

## Python
if ! fn_exists pyedit; then
	pyedit() {
		xpyc=$(
			python <<-EOF
				import os, sys
				f = open(os.devnull, 'w')
				sys.stderr = f
				module = __import__('$1')
				sys.stdout.write(module.__file__)
			EOF
		)

		if [ -n "$xpyc" ]; then
			echo "Python module $1 not found"
			return 1

		else
			case "$xpyc" in
				*__init__.py*)
					xpydir=$(dirname "$xpyc")
					echo "$EDITOR $xpydir"
					$EDITOR "$xpydir"
					;;
				*)
					echo "$EDITOR ${xpyc%.*}.py"
					$EDITOR "${xpyc%.*}.py"
					;;
			esac
		fi
	}
fi
# }}}

## Others
if ! fn_exists findicon; then
	findicon() {
		icon="$1"
		# Determine the current icon theme
		theme=$(gsettings get org.gnome.desktop.interface icon-theme) # Has quotes
		# Determine the icon file using the XDG Icon File Specification
		# (http://standards.freedesktop.org/icon-theme-spec)
		# Try various sizes, preferring the larger ones
		for i in 256 128 96 64 48 32 24 22; do
			iconfile=$(
				python2 <<-EOF
					from xdg import IconTheme
					print IconTheme.getIconPath('$icon',$i,$theme,['png', 'svg'])
				EOF
			)
			if [ -e "$iconfile" ]; then break; fi
		done

		# If this has failed, then $icon probably doesn't have an icon file
		if [ ! -e "$iconfile" ]; then
			echo "E: Could not find icon file for icon name '$icon'."
			return 1
		fi

		echo "$iconfile"
	}
fi

if ! fn_exists relpath; then
	relpath() {
		python <<-EOF
			from os.path import relpath
			print(relpath('$1','${2:-$PWD}'))
		EOF
	}
fi

if ! fn_exists calc; then
	calc() {
		echo "scale=3;$*" | bc -l
	}
fi

if ! fn_exists todo; then
	todo() {
		if [ ! -f "$HOME/.todo" ]; then
			touch "$HOME/.todo"
		fi

		if [ $# -eq 0 ]; then
			cat "$HOME/.todo"
		elif [ "$1" = "-l" ]; then
			cat -n "$HOME/.todo"
		elif [ "$1" = "-c" ]; then
			echo "" >"$HOME/.todo"
		elif [ "$1" = "-r" ]; then
			cat -n "$HOME/.todo"
			echo -n "----------------------------\\nType a number to remove: "
			read -r NUMBER
			sed -ie "${NUMBER}d" "$HOME/.todo"
		else
			echo "$@" >>"$HOME/.todo"
		fi
	}
fi

if ! fn_exists quiet; then
	quiet() {
		"$@" >/dev/null 2>&1 &
	}
fi

if ! fn_exists usage; then
	usage() {
		if [ -n "$1" ]; then
			du -h --max-depth=1 "$1"
		else
			du -h --max-depth=1
		fi
	}
fi

if ! fn_exists ips; then
	ips() {
		if command -v ifconfig >/dev/null 2>&1; then
			ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
		elif command -v ip >/dev/null 2>&1; then
			ip addr | grep -oP 'inet \K[\d.]+'
		else
			echo "You don't have ifconfig or ip command installed!"
		fi
	}
fi

if ! fn_exists down4me; then
	down4me() {
		curl -Ls "http://downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
	}
fi

if ! fn_exists myip; then
	myip() {
		for url in "https://ipinfo.io/ip" "http://checkip.dyndns.com/" \
			"http://checkip.dyndns.org/"; do
			res=$(curl -s "${url}")
			if [ -n "$res" ]; then
				break
			fi
		done
		res=$(echo "$res" | grep -Eo '[0-9\.]+')
		echo "Your public IP is: $res"
	}
fi

if ! fn_exists pickfrom; then
	pickfrom() {
		local file
		file=$1
		[ -z "$file" ] && echo "File required" && return
		length=$(wc -l "$file" | cut -d" " -f1)
		random=$(shuf -i 0-32767 -n)
		n=$((random * length / 32768 + 1))
		head -n $n "$file" | tail -1
	}
fi

if ! fn_exists passgen; then
	passgen() {
		local pass
		local length
		length=${1:-4}
		pass=$(for i in $(seq 1 $length); do
			pickfrom /usr/share/dict/cracklib-small
		done |
			xargs echo)
		echo "With spaces (easier to memorize): $pass"
		echo "Without (use this as the password): $(echo "$pass" | tr -d ' ')"
	}
fi

if ! fn_exists command_exists; then
	command_exists() {
		type "$1" >/dev/null 2>&1
	}
fi

if ! fn_exists buf; then
	# useful for administrators and configs
	buf() {
		local filename
		filename=$1
		local filetime
		filetime=$(date +%Y%m%d_%H%M%S)
		cp -a "${filename}" "${filename}_${filetime}"
	}
fi

if ! fn_exists myshell; then
	myshell() {
		#ps -p $$ -o cmd --no-headers | cut -d' ' -f1
		ps -p $$ --no-headers | xargs echo | cut -d" " -f4
	}
fi

if ! fn_exists contains; then
	contains() {
		local str="$1" substr="$2"
		[ "$str" = "$substr" ] || [ -z "${str##$substr:*}" ] ||
			[ -z "${str##*:$substr:*}" ] || [ -z "${str%%*:$substr}" ]
	}
fi

#if ! fn_exists sanitize
#then
#function sanitize ()
#{
#shopt -s extglob
#filename=$(basename "$1")
#directory=$(dirname "$1")
#regexes=(
#'s/[\\/:\*\?"<>\|\x01-\x1F\x7F]//g'
#'s/^\(nul\|prn\|con\|lpt[0-9]\|com[0-9]\|aux\)\(\.\|$\)//i'
#)
#filename_clean=$(sed -e ${regexes[0]} -e ${regexes[1]} - <<< "$filename")
##shell-quote -- "$filename_clean"
#if [ "$filename" != "$filename_clean" ]; then
#mv -iv "$1" "$directory/$filename_clean"
#fi
#}
#fi

#if ! fn_exists sanitize_dir
#then
#function sanitize_dir ()
#{
#find "$1" -depth -exec bash -c 'sanitize "$0"' {} \;
#}
#fi

if ! fn_exists xsort; then
	xsort() {
		sort -u - | xargs echo
	}
fi

if ! fn_exists wait_for_disks; then
	wait_for_disks() {
		OLDIFS=$IFS
		# shellcheck disable=SC2046
		set -- $(printf "%s\n" "$@" | xsort)
		IFS='|'
		pattern="$*"
		IFS=" "
		result="$*"
		while :; do
			labels=$(systemctl -t mount | grep -E -o -e "$pattern" | xsort)
			if [ "$labels" = "$result" ]; then
				break
			fi
			sleep 1m
		done
		IFS=','
		echo 'Mounted disks : '"$*"
		IFS=$OLDIFS
	}
fi

#if ! fn_exists notify
#then
#function notify () {
#icon=${1:-"info"}
#title=${2:-$(basename "$0")}
#id=${3:-"$USER.$(basename "$0")"}
#timeout=${4:-5000}

#local body
## shellcheck disable=SC2162
#if read -t 0
#then
#body=$( \
#while IFS='' read -r line || [[ -n "$line" ]]; \
#do echo "$line"; \
#done)
#body=${body%%\n}
#fi

##python <<EOF
##import gi
##import time
##gi.require_version('Gio', '2.0')
##from gi.repository import Gio
##Application = Gio.Application.new("$id", Gio.ApplicationFlags.FLAGS_NONE)
##Application.register()
##Notification = Gio.Notification.new("$title")
##Notification.set_body('${body}')
##Icon = Gio.ThemedIcon.new("${icon}")
##Notification.set_icon(Icon)
##Application.send_notification("$id", Notification)
##time.sleep($timeout / 1000)
##Application.withdraw_notification("$id")
##EOF

#echo $body
#python <<EOF
#import notify2
#notify2.init('${id}', None)
#body = """$body"""
#n = notify2.Notification('${title}', message=body, icon='${icon}')
#try:
#timeout = int($timeout)
#if type(timeout) == int and timeout > 0:
#n.timeout = timeout
#else:
#n.timeout = notify2.EXPIRES_DEFAULT
#except:
#n.timeout = notify2.EXPIRES_NEVER
#n.show()
#EOF

##! ps -C gnome-panel && ! ps -C budgie-panel \
##&& NOTIFY_OPTS="-a" || NOTIFY_OPTS=""
##notify-send -t 1000 --hint=int:transient:1 -i "$1" $NOTIFY_OPTS "$2" "$3"
#}
#fi

#if ! fn_exists cpr; then
#function cpr() {
#rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 "$@"
#}
#fi

#if ! fn_exists mvr; then
#function mvr() {
#rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 --remove-source-files "$@"
#}
#fi

# TODO: Fix functions using bash only quoting mechanism
#if ! fn_exists strquote
#then
#function strquote () {
#declare -a items
#for item
#do
#value="${item@Q}"
#value="${value//\'\\\'\'/\'\"\'\"\'}"
#value="${value%%\'\'}"
#value="${value##\'\'}"
#items+=("$value")
#done

#set --  "${items[@]}"
#IFS=' ' ; echo "$*"
#}
#fi

#if ! fn_exists strseq
#then
#function strseq () {
#declare -a items
#for item
#do
#value="${item@Q}"
#value="${value//\'\\\'\'/\'\"\'\"\'}"
#value="${value%%\'\'}"
#value="${value##\'\'}"
#items+=("$value")
#done

#set --  "${items[@]}"
#IFS="," ; echo "$*"
#}
#fi

#if ! fn_exists strjoin
#then
#function strjoin ()
#{
#sep=${1@Q}
#sep=${sep#\$}
#shift

#res=""
#sep2=$(eval echo "$sep")
#for arg
#do
#[ -z "$res" ] && \
#res="$arg" && continue
#res="${res}$sep2${arg}"
#done
#echo -e "$res"

##python <<-EOF
### -*- coding: utf-8 -*-
##sep = $sep
##items = [$(strseq "$@")]
##print(sep.join(items))
##EOF
#}
#fi

# }}}
