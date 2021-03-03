#!/bin/sh
# vim: set filetype=sh foldmethod=indent ai ts=4 sw=4 tw=79:

## Extract
if ! fn_exists extract; then
	function extract() {
		local opt
		local OPTIND=1
		while getopts "hv" opt; do
			case "$opt" in
			h)
				cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] <archives>
	options:
		-h  show this message and exit
		-v  verbosely list files processed
End-Of-Usage
				return
				;;
			v)
				local -r verbose='v'
				;;
			?)
				extract -h >&2
				return 1
				;;
			esac
		done
		shift $((OPTIND - 1))

		[ $# -eq 0 ] && extract -h && return 1
		while [ $# -gt 0 ]; do
			if [ -f "$1" ]; then
				case "$1" in
				*.tar.bz2 | *.tbz | *.tbz2) tar "x${verbose}jf" "$1" ;;
				*.tar.gz | *.tgz) tar "x${verbose}zf" "$1" ;;
				*.tar.xz)
					xz --decompress "$1"
					set -- "$@" "${1:0:-3}"
					;;
				*.tar.Z)
					uncompress "$1"
					set -- "$@" "${1:0:-2}"
					;;
				*.bz2) bunzip2 "$1" ;;
				*.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
				*.pax.gz)
					gunzip "$1"
					set -- "$@" "${1:0:-3}"
					;;
				*.gz) gunzip "$1" ;;
				*.pax) pax -r -f "$1" ;;
				*.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
				*.rar) unrar x "$1" ;;
				*.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
				*.tar) tar "x${verbose}f" "$1" ;;
				*.txz)
					mv "$1" "${1:0:-4}.tar.xz"
					set -- "$@" "${1:0:-4}.tar.xz"
					;;
				*.xz) xz --decompress "$1" ;;
				*.zip | *.war | *.jar) unzip "$1" ;;
				*.Z) uncompress "$1" ;;
				*.7z) 7za x "$1" ;;
				*) echo "'$1' cannot be extracted via extract" >&2 ;;
				esac
			else
				echo "extract: '$1' is not a valid file" >&2
			fi
			shift
		done
	}
fi
# }}}

if ! fn_exists start_if_inactive; then
	start_if_inactive() {
		[ $# -eq 0 ] && return 1

		declare -a inactive
		while IFS='' read -r state || [[ -n "$state" ]]; do
			[ "$state" = "active" ] || inactive+=("$1")
			[ "$state" = "active" ] && echo "$1 was active" ||
				echo "$1 is inactive"
			shift
		done < <(systemctl is-active "$@")

		[ ${#inactive[@]} -gt 0 ] && sudo systemctl start "${inactive[@]}"

		true
	}
fi

if ! fn_exists start_if_user_inactive; then
	start_if_user_inactive() {
		[ $# -eq 0 ] && return 1

		declare -a inactive
		while IFS='' read -r state || [[ -n "$state" ]]; do
			[ "$state" = "active" ] || inactive+=("$1")
			[ "$state" = "active" ] && echo "$1 was active" ||
				echo "$1 is inactive"
			shift
		done < <(systemctl --user is-active "$@")

		[ ${#inactive[@]} -gt 0 ] && systemctl --user start "${inactive[@]}"

		true
	}
fi

if ! fn_exists pause; then
	pause() {
		echo
		echo -n "Appuyez sur une touche pour continuer..."
		# shellcheck disable=SC2034
		read -r -n 1 key >/dev/null 2>&1
		echo
	}
fi

if ! fn_exists thatis; then
	thatis() {
		local viewer="${PAGER:-less}"
		local opt
		local OPTIND=1
		while getopts "h" opt; do
			case "$opt" in
			h)
				cat <<-EOF
					Usage:
					\t${FUNCNAME[0]} <command|alias|function>…
					\t${FUNCNAME[0]} -h
					Show command script, alias definition or function declaration.

					options:
					\t-h Show this message and exit
				EOF
				return
				;;
			?)
				#extract -h >&2
				return 1
				;;
			esac
		done
		shift $((OPTIND - 1))

		[ $# -eq 0 ] && ${FUNCNAME[0]} -h && return 1

		for cmd in "$@"; do
			type $cmd 2>&1 | head -n1

			tmpfile=$(mktemp -u -p /tmp)
			LC_ALL=C type $cmd 2>&1 | head -n1 >$tmpfile

			_type="not found"
			script=""

			if grep -qE -e "is aliased|is an alias" $tmpfile; then
				_type="alias"
			elif grep -qE -e "is a (|shell )function" $tmpfile; then
				_type="function"
			elif grep -q "is a shell builtin" $tmpfile; then
				_type="builtin"
			elif grep -qE -e "^$cmd is" $tmpfile; then
				# regular command in PATH
				script=$(<$tmpfile)
				script="${script//$cmd is /}"
				if file $(realpath "$script") 2>&1 | grep -qE -e ",.*text.*"; then
					_type="text"
				else
					_type="binary"
				fi
			fi

			case $_type in
			"alias") ;;

			"function")
				declare -f $cmd
				;;
			"text")
				$viewer "$script"
				;;
			*) ;;

			esac

			/usr/bin/rm  -f "$tmpfile"
		done
	}
fi

