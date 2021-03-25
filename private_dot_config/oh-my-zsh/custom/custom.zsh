# vim: set filetype=zsh foldmethod=indent ai ts=4 sw=4 tw=79:

# setting some default values
NOCOR=${NOCOR:-0}
NOMENU=${NOMENU:-0}
ZSH_NO_DEFAULT_LOCALE=${ZSH_NO_DEFAULT_LOCALE:-0}


#f1# are we running within an utf environment?
function isutfenv () {
	case "$LANG $CHARSET $LANGUAGE" in
		*utf*) return 0 ;;
		*UTF*) return 0 ;;
		*)     return 1 ;;
	esac
}

# check for user, if not running as root set $SUDO to sudo
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# set some important options (as early as possible)

# warning if file exists ('cat /dev/null > ~/.zshrc')
setopt NO_clobber
# don't warn me about bg processes when exiting
setopt nocheckjobs
# for autocompletion of command line switches for aliases
setopt COMPLETE_ALIASES

# History
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
## append history list to the history file; this is the default but we make sure
## because it's required for share_history.
#setopt append_history
## import new commands from the history file also in other zsh-session
#setopt share_history
# This option is a variant of INC_APPEND_HISTORY in  which,  where possible, 
# the history entry is written out to the file after the command is finished,
# so that the time taken by  the  command  is recorded  correctly in the 
# history file in EXTENDED_HISTORY format.
setopt inc_append_history_time
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups
# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

setopt HIST_ALLOW_CLOBBER
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

ignore_prefixes=('exit' 'hist' 'echo' 'man' 'ls' 'dir' 'pikaur -Syu' 
	'sudo pacman -Syu' 'cd' 'less'  'htop' 'cls' 'which' 'type' 'kill'
	'whoami' 'xprop' 'obxprop' 'pkgfile' 'pgg' 'run-help')
prefixes=""
for arg in "${ignore_prefixes[@]}"
do
	[ -n "$prefixes" ] && prefixes="${prefixes}|${arg}" || prefixes="$arg"
done
#export HISTORY_IGNORE=$(printf "'(&|[ ]*|%s)'" "$prefixes")
export HISTORY_IGNORE=$(printf "(%s)" "$prefixes")

function zshaddhistory() {
	emulate -L zsh
	## uncomment if HISTORY_IGNORE
	## should use EXTENDED_GLOB syntax
	setopt extendedglob
	#[[ $1 != ${~HISTORY_IGNORE} ]]
	! [[ $1 =~ ^$HISTORY_IGNORE ]]
}

# History search
#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#[[ -n "${key[Up]}"   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
#[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search


# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
setopt extendedglob
# display PID when suspending processes as well
setopt longlistjobs
# report the status of backgrounds jobs immediately
setopt notify
# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# Don't send SIGHUP to background processes when the shell exits.
setopt nohup
# make cd push the old directory onto the directory stack.
setopt auto_pushd
# avoid "beep"ing
setopt nobeep
# don't push the same dir twice.
setopt pushd_ignore_dups
# * shouldn't match dotfiles. ever.
setopt noglobdots
# use zsh style word splitting
setopt noshwordsplit
# don't error out when unset parameters are used
setopt unset
# Allow comments even in interactive shells
setopt interactivecomments

# Colors on GNU

typeset -ga ls_options
typeset -ga grep_options

ls_options+=( --color=auto -v )
grep_options+=( --color=auto )

# # Colors on GNU ls(1)
# if ls --color=auto / >/dev/null 2>&1; then
#     ls_options+=( --color=auto )
#     # Colors on FreeBSD and OSX ls(1)
# elif ls -G / >/dev/null 2>&1; then
#     ls_options+=( -G )
# fi
#
# # Natural sorting order on GNU ls(1)
# # OSX and IllumOS have a -v option that is not natural sorting
# if ls --version |& grep -q 'GNU' >/dev/null 2>&1 && ls -v / >/dev/null 2>&1; then
#     ls_options+=( -v )
# fi
#
# # Color on GNU and FreeBSD grep(1)
# if grep --color=auto -q "a" <<< "a" >/dev/null 2>&1; then
#     grep_options+=( --color=auto )
# fi

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# watch for everyone but me and root
watch=(notme root)

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# Load a few modules
for mod in parameter complist deltochar mathfunc ; do
	zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done && builtin unset -v mod

# autoload zsh modules when they are referenced
zmodload -a  zsh/stat    zstat
zmodload -a  zsh/zpty    zpty
zmodload -ap zsh/mapfile mapfile


# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload () {
	emulate -L zsh
	setopt extended_glob
	local fdir ffile
	local -i ffound

	ffile=$1
	(( ffound = 0 ))
	for fdir in ${fpath} ; do
		[[ -e ${fdir}/${ffile} ]] && (( ffound = 1 )) && break
	done

	(( ffound == 0 )) && return 1
	# if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
	#     autoload -U ${ffile} || return 1
	# else
	#     autoload ${ffile} || return 1
	# fi
	autoload -U ${ffile} || return 1
	return 0
}

# completion system
# COMPDUMPFILE=${COMPDUMPFILE:-${ZDOTDIR:-${HOME}}/.zcompdump}
# if zrcautoload compinit ; then
#     typeset -a tmp
#     zstyle -a ':grml:completion:compinit' arguments tmp
#     compinit -d ${COMPDUMPFILE} "${tmp[@]}" || print 'Notice: no compinit available :('
#     unset tmp
# else
#     print 'Notice: no compinit available :('
#     function compdef { }
# fi

if (( ${+_comps} )) ; then
	# TODO: This could use some additional information

	## Make sure the completion system is initialised
	#(( ${+_comps} )) || return 1

	# allow one error for every three characters typed in approximate completer
	zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

	# don't complete backup files as executables
	zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

	# start menu completion only if it could find no unambiguous initial string
	zstyle ':completion:*:correct:*'       insert-unambiguous true
	zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
	zstyle ':completion:*:correct:*'       original true

	# activate color-completion
	zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

	# format on completion
	zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

	# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
	zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

	# insert all expansions for expand completer
	zstyle ':completion:*:expand:*'        tag-order all-expansions
	zstyle ':completion:*:history-words'   list false

	# activate menu
	zstyle ':completion:*:history-words'   menu yes

	# ignore duplicate entries
	zstyle ':completion:*:history-words'   remove-all-dups yes
	zstyle ':completion:*:history-words'   stop yes

	# match uppercase from lowercase
	zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

	# separate matches into groups
	zstyle ':completion:*:matches'         group 'yes'
	zstyle ':completion:*'                 group-name ''

	if [[ "$NOMENU" -eq 0 ]] ; then
		# if there are more than 5 options allow selecting from a menu
		zstyle ':completion:*'               menu select=5
	else
		# don't use any menus at all
		setopt no_auto_menu
	fi

	zstyle ':completion:*:messages'        format '%d'
	zstyle ':completion:*:options'         auto-description '%d'

	# describe options in full
	zstyle ':completion:*:options'         description 'yes'

	# on processes completion complete all user processes
	zstyle ':completion:*:processes'       command 'ps -au$USER'

	# offer indexes before parameters in subscripts
	zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

	# provide verbose completion information
	zstyle ':completion:*'                 verbose true

	# recent (as of Dec 2007) zsh versions are able to provide descriptions
	# for commands (read: 1st word in the line) that it will list for the user
	# to choose from. The following disables that, because it's not exactly fast.
	zstyle ':completion:*:-command-:*:'    verbose false

	# set format for warnings
	zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

	# define files to ignore for zcompile
	zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
	zstyle ':completion:correct:'          prompt 'correct to: %e'

	# Ignore completion functions for commands you don't have:
	zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

	# Provide more processes in completion of programs like killall:
	zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

	# complete manual by their section
	zstyle ':completion:*:manuals'    separate-sections true
	zstyle ':completion:*:manuals.*'  insert-sections   true
	zstyle ':completion:*:man:*'      menu yes select

	# Search path for sudo completion
	zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
		/usr/local/bin  \
		/usr/sbin       \
		/usr/bin        \
		/sbin           \
		/bin            \
		/usr/X11R6/bin

	# provide .. as a completion
	#zstyle ':completion:*' special-dirs ..
	# the default grml setup provides '..' as a completion. it does not provide
	# '.' though. If you want that too, use the following line:
	zstyle ':completion:*' special-dirs true

	# run rehash on completion so new installed program are found automatically:
	function _force_rehash () {
		(( CURRENT == 1 )) && rehash
		return 1
	}

	## correction
	# some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
	if [[ "$NOCOR" -gt 0 ]] ; then
		zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
		setopt nocorrect
	else
		# try to be smart about when to use what completer...
		setopt correct
		zstyle -e ':completion:*' completer '
		if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
			_last_try="$HISTNO$BUFFER$CURSOR"
			reply=(_complete _match _ignored _prefix _files)
		else
			if [[ $words[1] == (rm|mv) ]] ; then
				reply=(_complete _files)
			else
				reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
			fi
		fi'
	fi

	# command for process lists, the local web server details and host completion
	zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

	# Some functions, like _apt and _dpkg, are very slow. We can use a cache in
	# order to speed things up
	if [[ ${COMP_CACHING:-yes} == yes ]]; then
		COMP_CACHE_DIR=${COMP_CACHE_DIR:-${ZDOTDIR:-$HOME}/.cache}
		if [[ ! -d ${COMP_CACHE_DIR} ]]; then
			command mkdir -p "${COMP_CACHE_DIR}"
		fi
		zstyle ':completion:*' use-cache  yes
		zstyle ':completion:*:complete:*' cache-path "${COMP_CACHE_DIR}"
	fi

	# host completion
	[[ -r ~/.ssh/config ]] && _ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*}) || _ssh_config_hosts=()
	[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
	[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
		hosts=(
			$(hostname)
			"$_ssh_config_hosts[@]"
			"$_ssh_hosts[@]"
			"$_etc_hosts[@]"
			localhost
		)
		zstyle ':completion:*:hosts' hosts $hosts
		# TODO: so, why is this here?
		#  zstyle '*' hosts $hosts

	# use generic completion system for programs not yet defined; (_gnu_generic works
	# with commands that provide a --help option with "standard" gnu-like output.)
	for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
		pal stow uname ; do
			[[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
		done; unset compcom

	# see upgrade function in this file
	compdef _hosts upgrade
fi

# utility functions
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
function check_com () {
	emulate -L zsh
	local -i comonly gatoo
	comonly=0
	gatoo=0

	if [[ $1 == '-c' ]] ; then
		comonly=1
		shift 1
	elif [[ $1 == '-g' ]] ; then
		gatoo=1
		shift 1
	fi

	if (( ${#argv} != 1 )) ; then
		printf 'usage: check_com [-c|-g] <command>\n' >&2
		return 1
	fi

	if (( comonly > 0 )) ; then
		(( ${+commands[$1]}  )) && return 0
		return 1
	fi

	if     (( ${+commands[$1]}    )) \
		|| (( ${+functions[$1]}   )) \
		|| (( ${+aliases[$1]}     )) \
		|| (( ${+reswords[(r)$1]} )) ; then
			return 0
	fi

	if (( gatoo > 0 )) && (( ${+galiases[$1]} )) ; then
		return 0
	fi

	return 1
}

# Keyboard setup: The following is based on the same code, we wrote for
# debian's setup. It ensures the terminal is in the right mode, when zle is
# active, so the values from $terminfo are valid. Therefore, this setup should
# work on all systems, that have support for `terminfo'. It also requires the
# zsh in use to have the `zsh/terminfo' module built.
#
# If you are customising your `zle-line-init()' or `zle-line-finish()'
# functions, make sure you call the following utility functions in there:
#
#     - zle-line-init():      zle-smkx
#     - zle-line-finish():    zle-rmkx

# Use emacs-like key bindings by default:
bindkey -e

# Custom widgets:

## beginning-of-line OR beginning-of-buffer OR beginning of history
## by: Bart Schaefer <schaefer@brasslantern.com>, Bernhard Tittelbach
function beginning-or-end-of-somewhere () {
	local hno=$HISTNO
	if [[ ( "${LBUFFER[-1]}" == $'\n' && "${WIDGET}" == beginning-of* ) || \
		( "${RBUFFER[1]}" == $'\n' && "${WIDGET}" == end-of* ) ]]; then
			zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
		else
			zle .${WIDGET:s/somewhere/line-hist/} "$@"
			if (( HISTNO != hno )); then
				zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
			fi
	fi
}
zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere

# a generic accept-line wrapper

# This widget can prevent unwanted autocorrections from command-name
# to _command-name, rehash automatically on enter and call any number
# of builtin and user-defined widgets in different contexts.
#
# For a broader description, see:
# <http://bewatermyfriend.org/posts/2007/12-26.11-50-38-tooltime.html>
#
# The code is imported from the file 'zsh/functions/accept-line' from
# <http://ft.bewatermyfriend.org/comp/zsh/zsh-dotfiles.tar.bz2>, which
# distributed under the same terms as zsh itself.

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true

function Accept-Line () {
	setopt localoptions noksharrays
	local -a subs
	local -xi aldone
	local sub
	local alcontext=${1:-$alcontext}

	zstyle -a ":acceptline:${alcontext}" actions subs

	(( ${#subs} < 1 )) && return 0

	(( aldone = 0 ))
	for sub in ${subs} ; do
		[[ ${sub} == 'accept-line' ]] && sub='.accept-line'
		zle ${sub}

		(( aldone > 0 )) && break
	done
}

function Accept-Line-getdefault () {
	emulate -L zsh
	local default_action

	zstyle -s ":acceptline:${alcontext}" default_action default_action
	case ${default_action} in
		((accept-line|))
			printf ".accept-line"
			;;
		(*)
			printf ${default_action}
			;;
	esac
}

function Accept-Line-HandleContext () {
	zle Accept-Line

	default_action=$(Accept-Line-getdefault)
	zstyle -T ":acceptline:${alcontext}" call_default \
		&& zle ${default_action}
	}

function accept-line () {
	setopt localoptions noksharrays
	local -a cmdline
	local -x alcontext
	local buf com fname format msg default_action

	alcontext='default'
	buf="${BUFFER}"
	cmdline=(${(z)BUFFER})
	com="${cmdline[1]}"
	fname="_${com}"

	Accept-Line 'preprocess'

	zstyle -t ":acceptline:${alcontext}" rehash \
		&& [[ -z ${commands[$com]} ]]           \
		&& rehash

	if    [[ -n ${com}               ]] \
		&& [[ -n ${reswords[(r)$com]} ]] \
		|| [[ -n ${aliases[$com]}     ]] \
		|| [[ -n ${functions[$com]}   ]] \
		|| [[ -n ${builtins[$com]}    ]] \
		|| [[ -n ${commands[$com]}    ]] ; then

		# there is something sensible to execute, just do it.
		alcontext='normal'
		Accept-Line-HandleContext

		return
	fi

	if    [[ -o correct              ]] \
		|| [[ -o correctall           ]] \
		&& [[ -n ${functions[$fname]} ]] ; then

		# nothing there to execute but there is a function called
		# _command_name; a completion widget. Makes no sense to
		# call it on the commandline, but the correct{,all} options
		# will ask for it nevertheless, so warn the user.
		if [[ ${LASTWIDGET} == 'accept-line' ]] ; then
			# Okay, we warned the user before, he called us again,
			# so have it his way.
			alcontext='force'
			Accept-Line-HandleContext

			return
		fi

		if zstyle -t ":acceptline:${alcontext}" nocompwarn ; then
			alcontext='normal'
			Accept-Line-HandleContext
		else
			# prepare warning message for the user, configurable via zstyle.
			zstyle -s ":acceptline:${alcontext}" compwarnfmt msg

			if [[ -z ${msg} ]] ; then
				msg="%c will not execute and completion %f exists."
			fi

			zformat -f msg "${msg}" "c:${com}" "f:${fname}"

			zle -M -- "${msg}"
		fi
		return
	elif [[ -n ${buf//[$' \t\n']##/} ]] ; then
		# If we are here, the commandline contains something that is not
		# executable, which is neither subject to _command_name correction
		# and is not empty. might be a variable assignment
		alcontext='misc'
		Accept-Line-HandleContext

		return
	fi

	# If we got this far, the commandline only contains whitespace, or is empty.
	alcontext='empty'
	Accept-Line-HandleContext
}

zle -N accept-line
zle -N Accept-Line
zle -N Accept-Line-HandleContext

## complete word from currently visible Screen or Tmux buffer.
if check_com -c screen || check_com -c tmux; then
	function _complete_screen_display () {
		[[ "$TERM" != "screen" ]] && return 1

		local TMPFILE=$(mktemp)
		local -U -a _screen_display_wordlist
		trap "rm -f $TMPFILE" EXIT

		# fill array with contents from screen hardcopy
		if ((${+TMUX})); then
			#works, but crashes tmux below version 1.4
			#luckily tmux -V option to ask for version, was also added in 1.4
			tmux -V &>/dev/null || return
			tmux -q capture-pane \; save-buffer -b 0 $TMPFILE \; delete-buffer -b 0
		else
			screen -X hardcopy $TMPFILE
			# screen sucks, it dumps in latin1, apparently always. so recode it
			# to system charset
			check_com recode && recode latin1 $TMPFILE
		fi
		_screen_display_wordlist=( ${(QQ)$(<$TMPFILE)} )
		# remove PREFIX to be completed from that array
		_screen_display_wordlist[${_screen_display_wordlist[(i)$PREFIX]}]=""
		compadd -a _screen_display_wordlist
	}
#m# k CTRL-x\,\,\,S Complete word from GNU screen buffer
bindkey -r "^xS"
compdef -k _complete_screen_display complete-word '^xS'
fi

# Load a few more functions and tie them to widgets, so they can be bound:

function zrcautozle () {
	emulate -L zsh
	local fnc=$1
	zrcautoload $fnc && zle -N $fnc
}

function zrcgotwidget () {
	(( ${+widgets[$1]} ))
}

function zrcgotkeymap () {
	[[ -n ${(M)keymaps:#$1} ]]
}

if zrcautoload history-search-end; then
	zle -N history-beginning-search-backward-end history-search-end
	zle -N history-beginning-search-forward-end  history-search-end
fi
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history

# The actual terminal setup hooks and bindkey-calls:

# An array to note missing features to ease diagnosis in case of problems.
typeset -ga grml_missing_features

function zrcbindkey () {
	if (( ARGC )) && zrcgotwidget ${argv[-1]}; then
		bindkey "$@"
	fi
}

function bind2maps () {
	local i sequence widget
	local -a maps

	while [[ "$1" != "--" ]]; do
		maps+=( "$1" )
		shift
	done
	shift

	if [[ "$1" == "-s" ]]; then
		shift
		sequence="$1"
	else
		sequence="${key[$1]}"
	fi
	widget="$2"

	[[ -z "$sequence" ]] && return 1

	for i in "${maps[@]}"; do
		zrcbindkey -M "$i" "$sequence" "$widget"
	done
}

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-smkx () {
		emulate -L zsh
		printf '%s' ${terminfo[smkx]}
	}
	function zle-rmkx () {
		emulate -L zsh
		printf '%s' ${terminfo[rmkx]}
	}
	function zle-line-init () {
		zle-smkx
	}
	function zle-line-finish () {
		zle-rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
else
	for i in {s,r}mkx; do
		(( ${+terminfo[$i]} )) || grml_missing_features+=($i)
	done
	unset i
fi

typeset -A key
key=(
	Home     "${terminfo[khome]}"
	End      "${terminfo[kend]}"
	Insert   "${terminfo[kich1]}"
	Delete   "${terminfo[kdch1]}"
	Up       "${terminfo[kcuu1]}"
	Down     "${terminfo[kcud1]}"
	Left     "${terminfo[kcub1]}"
	Right    "${terminfo[kcuf1]}"
	PageUp   "${terminfo[kpp]}"
	PageDown "${terminfo[knp]}"
	BackTab  "${terminfo[kcbt]}"
)

# Guidelines for adding key bindings:
#
#   - Do not add hardcoded escape sequences, to enable non standard key
#     combinations such as Ctrl-Meta-Left-Cursor. They are not easily portable.
#
#   - Adding Ctrl characters, such as '^b' is okay; note that '^b' and '^B' are
#     the same key.
#
#   - All keys from the $key[] mapping are obviously okay.
#
#   - Most terminals send "ESC x" when Meta-x is pressed. Thus, sequences like
#     '\ex' are allowed in here as well.

bind2maps emacs             -- Home   beginning-of-somewhere
bind2maps       viins vicmd -- Home   vi-beginning-of-line
bind2maps emacs             -- End    end-of-somewhere
bind2maps       viins vicmd -- End    vi-end-of-line
bind2maps emacs viins       -- Insert overwrite-mode
bind2maps             vicmd -- Insert vi-insert
bind2maps emacs             -- Delete delete-char
bind2maps       viins vicmd -- Delete vi-delete-char
bind2maps emacs viins vicmd -- Up     up-line-or-search
bind2maps emacs viins vicmd -- Down   down-line-or-search
bind2maps emacs             -- Left   backward-char
bind2maps       viins vicmd -- Left   vi-backward-char
bind2maps emacs             -- Right  forward-char
bind2maps       viins vicmd -- Right  vi-forward-char

autoload -Uz insert-files
zle -N insert-files
#k# Insert files and test globbing
bind2maps emacs viins       -- -s "^xf" insert-files

autoload -Uz edit-command-line
zle -N edit-command-line
#k# Edit the current line in \kbd{\$EDITOR}
bind2maps emacs viins       -- -s '\ee' edit-command-line

#k# search history backward for entry beginning with typed text
bind2maps emacs viins       -- -s '^xp' history-beginning-search-backward-end
#k# search history forward for entry beginning with typed text
bind2maps emacs viins       -- -s '^xP' history-beginning-search-forward-end
#k# search history backward for entry beginning with typed text
bind2maps emacs viins       -- PageUp history-beginning-search-backward-end
#k# search history forward for entry beginning with typed text
bind2maps emacs viins       -- PageDown history-beginning-search-forward-end

# add a command line to the shells history without executing it
function commit-to-history () {
	print -s ${(z)BUFFER}
	zle send-break
}
zle -N commit-to-history
bind2maps emacs viins       -- -s "^x^h" commit-to-history

# only slash should be considered as a word separator:
function slash-backward-kill-word () {
	local WORDCHARS="${WORDCHARS:s@/@}"
	# zle backward-word
	zle backward-kill-word
}
zle -N slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\ev' slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\e^h' slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\e^?' slash-backward-kill-word

# Do history expansion on space:
#bind2maps emacs viins       -- -s ' ' magic-space

#k# Trigger menu-complete
bind2maps emacs viins       -- -s '\ei' menu-complete  # menu completion via esc-i

# press "ctrl-x d" to insert the actual date in the form yyyy-mm-dd
function insert-datestamp () { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp
#k# Insert a timestamp on the command line (yyyy-mm-dd)
bind2maps emacs viins       -- -s '^xd' insert-datestamp

# press esc-m for inserting last typed word again (thanks to caphuso!)
function insert-last-typed-word () { zle insert-last-word -- 0 -1 };
zle -N insert-last-typed-word;
#k# Insert last typed word
bind2maps emacs viins       -- -s "\em" insert-last-typed-word

function grml-zsh-fg () {
	if (( ${#jobstates} )); then
		zle .push-input
		[[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
		BUFFER="${BUFFER}fg"
		zle .accept-line
	else
		zle -M 'No background jobs. Doing nothing.'
	fi
}
zle -N grml-zsh-fg
#k# A smart shortcut for \kbd{fg<enter>}
bind2maps emacs viins       -- -s '^z' grml-zsh-fg

# run command line as user root via sudo:
function sudo-command-line () {
	[[ -z $BUFFER ]] && zle up-history
	if [[ $BUFFER != sudo\ * ]]; then
		BUFFER="sudo $BUFFER"
		CURSOR=$(( CURSOR+5 ))
	fi
}
zle -N sudo-command-line
#k# prepend the current command with "sudo"
#bind2maps emacs viins       -- -s '^os' sudo-command-line
bind2maps emacs viins       -- -s '\es' sudo-command-line

# run nocorrect command line
function nocorrect-command-line () {
	[[ -z $BUFFER ]] && return
	if [[ $BUFFER != nocorrect\ * ]]; then
		BUFFER="nocorrect $BUFFER"
		CURSOR=$(( CURSOR+10 ))
	fi
}
zle -N nocorrect-command-line
#k# prepend the current command with "nocorrect"
bind2maps emacs viins       -- -s '\en' nocorrect-command-line

### jump behind the first word on the cmdline.
### useful to add options.
function jump_after_first_word () {
	local words
	words=(${(z)BUFFER})

	if (( ${#words} <= 1 )) ; then
		CURSOR=${#BUFFER}
	else
		CURSOR=${#${words[1]}}
	fi
}
zle -N jump_after_first_word
#k# jump to after first word (for adding options)
bind2maps emacs viins       -- -s '^x1' jump_after_first_word

#k# complete word from history with menu
bind2maps emacs viins       -- -s "^x^x" hist-complete

# insert unicode character
# usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an §
# See for example http://unicode.org/charts/ for unicode characters code
autoload -Uz insert-unicode-char
zle -N insert-unicode-char
#k# Insert Unicode character
bind2maps emacs viins       -- -s '^xi' insert-unicode-char

# use the new *-pattern-* widgets for incremental history search
if zrcgotwidget history-incremental-pattern-search-backward; then
	for seq wid in '^r' history-incremental-pattern-search-backward \
		'^s' history-incremental-pattern-search-forward
		do
			bind2maps emacs viins vicmd -- -s $seq $wid
		done
		builtin unset -v seq wid
fi

if zrcgotkeymap menuselect; then
	#m# k Shift-tab Perform backwards menu completion
	bind2maps menuselect -- BackTab reverse-menu-complete

	#k# menu selection: pick item but stay in the menu
	bind2maps menuselect -- -s '\e^M' accept-and-menu-complete
	# also use + and INSERT since it's easier to press repeatedly
	bind2maps menuselect -- -s '+' accept-and-menu-complete
	bind2maps menuselect -- Insert accept-and-menu-complete

	# accept a completion and try to complete again by using menu
	# completion; very useful with completing directories
	# by using 'undo' one's got a simple file browser
	bind2maps menuselect -- -s '^o' accept-and-infer-next-history
fi

# Finally, here are still a few hardcoded escape sequences; Special sequences
# like Ctrl-<Cursor-key> etc do suck a fair bit, because they are not
# standardised and most of the time are not available in a terminals terminfo
# entry.
#
# While we do not encourage adding bindings like these, we will keep these for
# backward compatibility.

## use Ctrl-left-arrow and Ctrl-right-arrow for jumping to word-beginnings on
## the command line.
# URxvt sequences:
bind2maps emacs viins vicmd -- -s '\eOc' forward-word
bind2maps emacs viins vicmd -- -s '\eOd' backward-word
# These are for xterm:
bind2maps emacs viins vicmd -- -s '\e[1;5C' forward-word
bind2maps emacs viins vicmd -- -s '\e[1;5D' backward-word
## the same for alt-left-arrow and alt-right-arrow
# URxvt again:
bind2maps emacs viins vicmd -- -s '\e\e[C' forward-word
bind2maps emacs viins vicmd -- -s '\e\e[D' backward-word
# Xterm again:
bind2maps emacs viins vicmd -- -s '^[[1;3C' forward-word
bind2maps emacs viins vicmd -- -s '^[[1;3D' backward-word
# Also try ESC Left/Right:
bind2maps emacs viins vicmd -- -s '\e'${key[Right]} forward-word
bind2maps emacs viins vicmd -- -s '\e'${key[Left]}  backward-word

#f1# Edit an alias via zle
function edalias () {
	[[ -z "$1" ]] && { echo "Usage: edalias <alias_to_edit>" ; return 1 } || vared aliases'[$1]' ;
}
compdef _aliases edalias

#f1# Edit a function via zle
function edfunc () {
	[[ -z "$1" ]] && { echo "Usage: edfunc <function_to_edit>" ; return 1 } || zed -f "$1" ;
}
compdef _functions edfunc

#f1# Provides useful information on globbing
function H-Glob () {
	echo -e "
	/      directories
	.      plain files
	@      symbolic links
	=      sockets
	p      named pipes (FIFOs)
	*      executable plain files (0100)
	%      device files (character or block special)
	%b     block special files
	%c     character special files
	r      owner-readable files (0400)
	w      owner-writable files (0200)
	x      owner-executable files (0100)
	A      group-readable files (0040)
	I      group-writable files (0020)
	E      group-executable files (0010)
	R      world-readable files (0004)
	W      world-writable files (0002)
	X      world-executable files (0001)
	s      setuid files (04000)
	S      setgid files (02000)
	t      files with the sticky bit (01000)

	print *(m-1)          # Files modified up to a day ago
	print *(a1)           # Files accessed a day ago
	print *(@)            # Just symlinks
	print *(Lk+50)        # Files bigger than 50 kilobytes
	print *(Lk-50)        # Files smaller than 50 kilobytes
	print **/*.c          # All *.c files recursively starting in \$PWD
	print **/*.c~file.c   # Same as above, but excluding 'file.c'
	print (foo|bar).*     # Files starting with 'foo' or 'bar'
	print *~*.*           # All Files that do not contain a dot
	chmod 644 *(.^x)      # make all plain non-executable files publically readable
	print -l *(.c|.h)     # Lists *.c and *.h
	print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
	echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}
alias help-zshglob=H-Glob

# grep for running process, like: 'any vim'
function any () {
	emulate -L zsh
	unsetopt KSH_ARRAYS
	if [[ -z "$1" ]] ; then
		echo "any - grep for process(es) by keyword" >&2
		echo "Usage: any <keyword>" >&2 ; return 1
	else
		ps xauwww | grep -i "${grep_options[@]}" "[${1[1]}]${1[2,-1]}"
	fi
}

# useful functions

#f5# Backup \kbd{file_or_folder {\rm to} file_or_folder\_timestamp}
function bk () {
	emulate -L zsh
	local current_date=$(date -u "+%Y%m%dT%H%M%SZ")
	local clean keep move verbose result all to_bk
	setopt extended_glob
	keep=1
	while getopts ":hacmrv" opt; do
		case $opt in
			a) (( all++ ));;
			c) unset move clean && (( ++keep ));;
			m) unset keep clean && (( ++move ));;
			r) unset move keep && (( ++clean ));;
			v) verbose="-v";;
			h) <<-__EOF0__
				bk [-hcmv] FILE [FILE ...]
				bk -r [-av] [FILE [FILE ...]]
				Backup a file or folder in place and append the timestamp
				Remove backups of a file or folder, or all backups in the current directory

				Usage:
				-h    Display this help text
				-c    Keep the file/folder as is, create a copy backup using cp(1) (default)
				-m    Move the file/folder, using mv(1)
				-r    Remove backups of the specified file or directory, using rm(1). If none
					is provided, remove all backups in the current directory.
				-a    Remove all (even hidden) backups.
				-v    Verbose

				The -c, -r and -m options are mutually exclusive. If specified at the same time,
				the last one is used.

				The return code is the sum of all cp/mv/rm return codes.
				__EOF0__
				return 0;;
			\?) bk -h >&2; return 1;;
		esac
	done
	shift "$((OPTIND-1))"
	if (( keep > 0 )); then
		for to_bk in "$@"; do
			cp $verbose -a "${to_bk%/}" "${to_bk%/}_$current_date"
			(( result += $? ))
		done
	elif (( move > 0 )); then
		while (( $# > 0 )); do
			mv $verbose "${1%/}" "${1%/}_$current_date"
			(( result += $? ))
			shift
		done
	elif (( clean > 0 )); then
		if (( $# > 0 )); then
			for to_bk in "$@"; do
				rm $verbose -rf "${to_bk%/}"_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
				(( result += $? ))
			done
		else
			if (( all > 0 )); then
				rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z(D)
			else
				rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
			fi
			(( result += $? ))
		fi
	fi
	return $result
}

#f5# cd to directory and list files
function cl () {
	emulate -L zsh
	cd $1 && ls -a
}

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
	if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
		[[ ! -e ${1:h} ]] && return 1
		print "Correcting ${1} to ${1:h}"
		builtin cd ${1:h}
	else
		builtin cd "$@"
	fi
}

#f5# Create Directory and \kbd{cd} to it
function mkcd () {
	if (( ARGC != 1 )); then
		printf 'usage: mkcd <new-directory>\n'
		return 1;
	fi
	if [[ ! -d "$1" ]]; then
		command mkdir -p "$1"
	else
		printf '`%s'\'' already exists: cd-ing.\n' "$1"
	fi
	builtin cd "$1"
}

#f5# Create temporary directory and \kbd{cd} to it
function cdt () {
	builtin cd "$(mktemp -d)"
	builtin pwd
}

#f5# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
function accessed () {
	emulate -L zsh
	print -l -- *(a-${1:-1})
}

#f5# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
function changed () {
	emulate -L zsh
	print -l -- *(c-${1:-1})
}

#f5# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
function modified () {
	emulate -L zsh
	print -l -- *(m-${1:-1})
}
# modified() was named new() in earlier versions, add an alias for backwards compatibility
check_com new || alias new=modified

# use colors when GNU grep with color-support
if (( $#grep_options > 0 )); then
	o=${grep_options:+"${grep_options[*]}"}
	#a2# Execute \kbd{grep -{}-color=auto}
	alias grep='grep '$o
	alias egrep='egrep '$o
	unset o
fi

# Usage: simple-extract <file>
# Using option -d deletes the original archive file.
#f5# Smart archive extractor
function simple-extract () {
	emulate -L zsh
	setopt extended_glob noclobber
	local ARCHIVE DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
	local RC=0
	zparseopts -D -E "d=DELETE_ORIGINAL"
	for ARCHIVE in "${@}"; do
		case $ARCHIVE in
			*(tar.bz2|tbz2|tbz))
				DECOMP_CMD="tar -xvjf -"
				USES_STDIN=true
				USES_STDOUT=false
				;;
			*(tar.gz|tgz))
				DECOMP_CMD="tar -xvzf -"
				USES_STDIN=true
				USES_STDOUT=false
				;;
			*(tar.xz|txz|tar.lzma))
				DECOMP_CMD="tar -xvJf -"
				USES_STDIN=true
				USES_STDOUT=false
				;;
			*tar)
				DECOMP_CMD="tar -xvf -"
				USES_STDIN=true
				USES_STDOUT=false
				;;
			*rar)
				DECOMP_CMD="unrar x"
				USES_STDIN=false
				USES_STDOUT=false
				;;
			*lzh)
				DECOMP_CMD="lha x"
				USES_STDIN=false
				USES_STDOUT=false
				;;
			*7z)
				DECOMP_CMD="7z x"
				USES_STDIN=false
				USES_STDOUT=false
				;;
			*(zip|jar))
				DECOMP_CMD="unzip"
				USES_STDIN=false
				USES_STDOUT=false
				;;
			*deb)
				DECOMP_CMD="ar -x"
				USES_STDIN=false
				USES_STDOUT=false
				;;
			*bz2)
				DECOMP_CMD="bzip2 -d -c -"
				USES_STDIN=true
				USES_STDOUT=true
				;;
			*(gz|Z))
				DECOMP_CMD="gzip -d -c -"
				USES_STDIN=true
				USES_STDOUT=true
				;;
			*(xz|lzma))
				DECOMP_CMD="xz -d -c -"
				USES_STDIN=true
				USES_STDOUT=true
				;;
			*)
				print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
				RC=$((RC+1))
				continue
				;;
		esac

		if ! check_com ${DECOMP_CMD[(w)1]}; then
			echo "ERROR: ${DECOMP_CMD[(w)1]} not installed." >&2
			RC=$((RC+2))
			continue
		fi

		GZTARGET="${ARCHIVE:t:r}"
		if [[ -f $ARCHIVE ]] ; then

			print "Extracting '$ARCHIVE' ..."
			if $USES_STDIN; then
				if $USES_STDOUT; then
					${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
				else
					${=DECOMP_CMD} < "$ARCHIVE"
				fi
			else
				if $USES_STDOUT; then
					${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
				else
					${=DECOMP_CMD} "$ARCHIVE"
				fi
			fi
			[[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

		elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
			if check_com curl; then
				WGET_CMD="curl -L -s -o -"
			elif check_com wget; then
				WGET_CMD="wget -q -O -"
			elif check_com fetch; then
				WGET_CMD="fetch -q -o -"
			else
				print "ERROR: neither wget, curl nor fetch is installed" >&2
				RC=$((RC+4))
				continue
			fi
			print "Downloading and Extracting '$ARCHIVE' ..."
			if $USES_STDIN; then
				if $USES_STDOUT; then
					${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
					RC=$((RC+$?))
				else
					${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
					RC=$((RC+$?))
				fi
			else
				if $USES_STDOUT; then
					${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
				else
					${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
				fi
			fi

		else
			print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
			RC=$((RC+8))
		fi
	done
	return $RC
}

function __archive_or_uri () {
	_alternative \
		'files:Archives:_files -g "*.(#l)(tar.bz2|tbz2|tbz|tar.gz|tgz|tar.xz|txz|tar.lzma|tar|rar|lzh|7z|zip|jar|deb|bz2|gz|Z|xz|lzma)"' \
		'_urls:Remote Archives:_urls'
	}

function _simple_extract () {
	_arguments \
		'-d[delete original archivefile after extraction]' \
		'*:Archive Or Uri:__archive_or_uri'
	}
compdef _simple_extract simple-extract
alias se=simple-extract

#f5# Change the xterm title from within GNU-screen
function xtrename () {
	emulate -L zsh
	if [[ $1 != "-f" ]] ; then
		if [[ -z ${DISPLAY} ]] ; then
			printf 'xtrename only makes sense in X11.\n'
			return 1
		fi
	else
		shift
	fi
	if [[ -z $1 ]] ; then
		printf 'usage: xtrename [-f] "title for xterm"\n'
		printf '  renames the title of xterm from _within_ screen.\n'
		printf '  also works without screen.\n'
		printf '  will not work if DISPLAY is unset, use -f to override.\n'
		return 0
		fi
		print -n "\eP\e]0;${1}\C-G\e\\"
		return 0
	}

# Create small urls via http://goo.gl using curl(1).
# API reference: https://code.google.com/apis/urlshortener/
function zurl () {
	emulate -L zsh
	setopt extended_glob

	if [[ -z $1 ]]; then
		print "USAGE: zurl <URL>"
		return 1
	fi

	local PN url prog api json contenttype item
	local -a data
	PN=$0
	url=$1

	# Prepend 'http://' to given URL where necessary for later output.
	if [[ ${url} != http(s|)://* ]]; then
		url='http://'${url}
	fi

	if check_com -c curl; then
		prog=curl
	else
		print "curl is not available, but mandatory for ${PN}. Aborting."
		return 1
	fi
	api='https://www.googleapis.com/urlshortener/v1/url'
	contenttype="Content-Type: application/json"
	json="{\"longUrl\": \"${url}\"}"
	data=(${(f)"$($prog --silent -H ${contenttype} -d ${json} $api)"})
	# Parse the response
	for item in "${data[@]}"; do
		case "$item" in
			' '#'"id":'*)
				item=${item#*: \"}
				item=${item%\",*}
				printf '%s\n' "$item"
				return 0
				;;
		esac
	done
	return 1
}

#f2# Find history events by search pattern and list them by date.
function whatwhen () {
	emulate -L zsh
	local usage help ident format_l format_s first_char remain first last
	usage='USAGE: whatwhen [options] <searchstring> <search range>'
	help='Use `whatwhen -h'\'' for further explanations.'
	ident=${(l,${#${:-Usage: }},, ,)}
	format_l="${ident}%s\t\t\t%s\n"
	format_s="${format_l//(\\t)##/\\t}"
	# Make the first char of the word to search for case
	# insensitive; e.g. [aA]
	first_char=[${(L)1[1]}${(U)1[1]}]
	remain=${1[2,-1]}
	# Default search range is `-100'.
	first=${2:-\-100}
	# Optional, just used for `<first> <last>' given.
	last=$3
	case $1 in
		("")
			printf '%s\n\n' 'ERROR: No search string specified. Aborting.'
			printf '%s\n%s\n\n' ${usage} ${help} && return 1
			;;
		(-h)
			printf '%s\n\n' ${usage}
			print 'OPTIONS:'
			printf $format_l '-h' 'show help text'
			print '\f'
			print 'SEARCH RANGE:'
			printf $format_l "'0'" 'the whole history,'
			printf $format_l '-<n>' 'offset to the current history number; (default: -100)'
			printf $format_s '<[-]first> [<last>]' 'just searching within a give range'
			printf '\n%s\n' 'EXAMPLES:'
			printf ${format_l/(\\t)/} 'whatwhen grml' '# Range is set to -100 by default.'
			printf $format_l 'whatwhen zsh -250'
			printf $format_l 'whatwhen foo 1 99'
			;;
		(\?)
			printf '%s\n%s\n\n' ${usage} ${help} && return 1
			;;
		(*)
			# -l list results on stout rather than invoking $EDITOR.
			# -i Print dates as in YYYY-MM-DD.
			# -m Search for a - quoted - pattern within the history.
			fc -li -m "*${first_char}${remain}*" $first $last
			;;
	esac
}

# a wrapper for vim, that deals with title setting
#   VIM_OPTIONS
#       set this array to a set of options to vim you always want
#       to have set when calling vim (in .zshrc.local), like:
#           VIM_OPTIONS=( -p )
#       This will cause vim to send every file given on the
#       commandline to be send to it's own tab (needs vim7).
if check_com vim; then
	function vim () {
		VIM_PLEASE_SET_TITLE='yes' command vim ${VIM_OPTIONS} "$@"
	}
fi

