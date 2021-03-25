# vim: set filetype=sh foldmethod=marker ai ts=4 sw=4 tw=79:

# shellcheck disable=SC2139

# Python {{{
alias py='python'
alias ipy='ipython'

alias pip-list="pip list --user --outdated"
alias pip-install="pip install --user"
alias pip-uninstall="pip uninstall"
# }}}
# Clipboard {{{
case $OSTYPE in
linux*)
	XCLIP=$(command -v xclip)
	[ -n "$XCLIP" ] &&
		alias pbcopy="$XCLIP -selection clipboard" &&
		alias pbpaste="$XCLIP -selection clipboard -o"
	;;
esac
# }}}
## Make shell error tolerant # {{{
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
#alias -- -='cd -'        # Go back
# }}}
## Various {{{
alias ping='ping -c 5'
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias diff='colordiff' # requires colordiff package

alias pgg='ps -Af | grep' # requires an argument
alias psc='ps xawf -eo pid,user,cgroup,args'

alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias cls=' echo -ne "\033c"' # clear screen for real
# }}}
# Tree {{{
if [ ! -x "$(command -v tree 2>/dev/null)" ]; then
	alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi
# }}}
# Directory {{{
alias md='mkdir -p'
alias rd='rmdir'

# }}}
# Systemd {{{
alias cgls="systemd-cgls"
alias cgtop="systemd-cgtop"
alias sdr="systemd-run -G -d --quiet --user"

for c in "list-units" "is-active" "show" "help" "list-unit-files" \
	"is-enabled" "list-jobs" "show-environment" "cat" "list-timers"; do
	alias sc-$c="systemctl $c"
	alias scu-$c="systemctl --user $c"
done
for c in "start" "stop" "reload" "restart" "try-restart" "isolate" "kill" \
	"reset-failed" "enable" "disable" "reenable" "preset" "mask" "unmask" \
	"link" "load" "cancel" "set-environment" "unset-environment" \
	"edit" "daemon-reload"; do
	alias sc-$c="sudo systemctl $c"
	alias scu-$c="systemctl --user $c"
done

alias sc-status="systemctl status -l --no-pager"
alias sc-enable-now="sudo systemctl enable --now"
alias sc-disable-now="sudo systemctl disable --now"
alias sc-mask-now="sudo systemctl mask --now"

alias scu-status="systemctl --user status -l --no-pager"
alias scu-enable-now="systemctl --user enable --now"
alias scu-disable-now="systemctl --user disable --now"
alias scu-mask-now="systemctl --user mask --now"

alias sc='sudo systemctl '
alias scu='systemctl --user '
# }}}
# History {{{
alias h='fc -l -16 -1'
alias hs='fc -l 1 -1 | grep '
alias hsi='fc -l 1 -1 | grep -i '
# }}}
# Python {{{
# Find python file
alias pyfind='find . -name "*.py"'

# Remove python compiled byte-code and mypy cache in either current directory or in a
# list of specified directories
pyclean() {
	PYCLEAN_PLACES=${*:-'.'}
	find "${PYCLEAN_PLACES}" -type f -name "*.py[co]" -delete
	find "${PYCLEAN_PLACES}" -type d -name "__pycache__" -delete
	find "${PYCLEAN_PLACES}" -type d -name ".mypy_cache" -delete
}

# Grep among .py files
alias pygrep='grep --include="*.py"'
# }}}
### Pacman aliases # {{{
##if necessary, replace 'pacman' with your favorite AUR helper and adapt the commands accordingly
## default action    - install one or more packages
#alias pac="/usr/bin/pacman -S"
## '[u]pdate'        - upgrade all packages to their newest version
#alias pacu="/usr/bin/pacman -Syu"
## '[r]emove'        - uninstall one or more packages
#alias pacr="/usr/bin/pacman -Rs"
## '[s]earch'        - search for a package using one or more keywords
#alias pacs="/usr/bin/pacman -Ss"
## '[i]nfo'      - show information about a package
#alias paci="/usr/bin/pacman -Si"
## '[l]ist [o]rphans'    - list all packages which are orphaned
#alias paclo="/usr/bin/pacman -Qdt"
## '[c]lean cache'   - delete all not currently installed package files
#alias pacc="/usr/bin/pacman -Sc"
## '[l]ist [f]iles'  - list all files installed by a given package
#alias paclf="/usr/bin/pacman -Ql"
## 'mark as [expl]icit"  - mark one or more packages as explicitly installed
#alias pacexpl="/usr/bin/pacman -D --asexp"
## 'mark as [impl]icit'  - mark one or more packages as non explicitly installed
#alias pacimpl="/usr/bin/pacman -D --asdep"
## '[r]emove [o]rphans' - recursively remove ALL orphaned packages
#alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rs \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"
## }}}
# Pikaur {{{
#alias pikaur="nice ionice -c 3 -t /usr/bin/pikaur"
#alias pikaur="systemd-run -G --user --scope -p CPUQuota=33% /usr/bin/pikaur"
#alias pikaur="systemd-run -G --user -t -p CPUQuota=33% -p IOSchedulingClass=idle -p Nice=19  /usr/bin/pikaur"
# }}}
# Fasd {{{
alias v='sf -i -e nv'          # quick opening files with nvim
alias xv='sf -i -e qnv'        # quick opening files with nvim-qt
alias m='sf -i -e mpv'         # quick opening files with mpv
alias o='sf -i -e mimeo'       # quick opening files with xdg-open
alias e='sd -i -e FileManager' # quick opening directories with myexplorer
# }}}
# Restic {{{
alias resticprofile='python3 -m resticprofile -c $XDG_CONFIG_HOME/resticprofile/profiles.conf'
# }}}
# Tilix {{{
#alias tilix-add-right='tilix -a session-add-right'
#alias tilix-add-down='tilix -a session-add-down'
# }}}
# Others {{{
alias qnv='nvim-qt -- -u NONE'
alias nv='nvim -u NONE'
#alias vit_tmux='tmux new-window -n vit vit \; split-window -h -p 25 column -t -s\; -c 40 -N CMD,DESC -T DESC -d ~/Bureau/vit_help.txt'
alias Less='/usr/bin/less'

alias cpr='rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 '
alias mvr='rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 --remove-source-files '

# alias nicy="systemd-run -G --user -t -p CPUQuota=33% -p IOSchedulingClass=idle -p Nice=19  "
alias web='/usr/bin/elinks'
alias mutt='cd ~/Bureau && neomutt '
alias cm='chezmoi'
alias whatismyip='curl -s https://ipinfo.io/ip'
# alias tds='nocorrect urxvtc -name tmux -title tmux:debian@server -e ssh -t debian@server.gbroshome.info tmux attach'
# alias tcs='nocorrect urxvtc -name tmux -title tmux:canalguada@server -e ssh -t canalguada@server.gbroshome.info tmux attach'
# alias xnvim='urxvtc -name nvim -title nvim -e Cpu66 --slice -- /usr/bin/nvim '
alias xnvim='urxvtc -name nvim -title nvim -e nvim '
alias xelinks='urxvtc -name web -title elinks -e elinks '
alias urxvt-chfont="printf '\e]710;%s\007' "
# }}}
