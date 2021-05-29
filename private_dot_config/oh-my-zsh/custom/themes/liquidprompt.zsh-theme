# Only load Liquid Prompt in interactive shells, not from a script or from scp
[[ -o interactive ]] && . ~/git/liquidprompt/liquidprompt
# [[ $- = *i* ]] && source /usr/bin/liquidprompt

# vim: set filetype=zsh foldmethod=indent ai ts=4 sw=4 tw=79:
