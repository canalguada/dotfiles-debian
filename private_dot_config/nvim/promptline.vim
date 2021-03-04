"let g:promptline_theme = 'jelly'

let newline_slice = {
            \'function_name': 'newline',
            \'function_body': [
            \'function newline {',
            \'  printf "\n"',
            \'}']}

let git_sha_slice = {
            \'function_name': 'git_sha',
            \'function_body': [
            \'function git_sha {',
            \'  local sha',
            \'  sha=$(git rev-parse --short HEAD 2>/dev/null) || return 1',
            \'  printf "%s" "$sha"',
            \'}']}

let myuptime_slice = {
            \'function_name': 'myuptime',
            \'function_body': [
            \'function myuptime {',
            \'  local line',
            \'  local up',
            \'  local load',
            \'  line=$(uptime | sed "s/^ //" | sed "s/  / /g")',
            \'  up=${line%%,*}',
            \'  up=${up##*up }',
            \'  load=${line##*average: }',
            \'  load=${load%%, *}',
            \'  printf "%s %s" " $up" " $load"',
            \'}']}

let mydate_slice = {
            \'function_name': 'mydate',
            \'function_body': [
            \'function mydate {',
            \'  local hours_symbol=" "',
            \'  local ws=" "',
            \'  local trailing=""',
            \'  [[ "$KONSOLE"  -eq "1" ]] && { trailing=" "; ws=""; }',
            \'  printf "%s" "$hours_symbol$ws$(date +%H:%M:%S)$trailing"',
            \'}']}

let myuser_slice = {
            \'function_name': 'myuser',
            \'function_body': [
            \'function myuser {',
            \'  local name',
            \'  local symbol=" "',
            \'  local ws=" "',
            \'  local trailing=""',
            \'  [[ "$KONSOLE"  -eq "1" ]] && { trailing=" "; ws=""; }',
            \'  if [[ -n ${ZSH_VERSION-} ]]; then',
            \'  name=%n',
            \'  elif [[ -n ${FISH_VERSION-} ]]; then',
            \'  name="$USER"',
            \'  else name=\\u',
            \'  fi',
            \'  printf "%s" "$symbol$ws$name$trailing"',
            \'}']}

let g:promptline_theme = {
            \'a'      : [220, 166],
            \'b'      : [231, 31],
            \'c'      : [250, 240],
            \'x'      : [250, 236],
            \'y'      : [250, 236],
            \'z'      : [250, 236],
            \'user'   : [250, 233],
            \'jobs'   : [250, 240],
            \'cwd'    : [232, 4],
            \'sys'    : [232, 166],
            \'venv'   : [232, 70],
            \'vcs'    : [232, 70],
            \'time'   : [232, 253],
            \'warn'   : [232, 196]}

"let prompt_options = {
            "\'left_sections' : [ 'user', 'jobs', 'cwd' ],
            "\'right_sections' : [ 'warn', 'sys', 'venv', 'vcs', 'time' ],
            "\'left_only_sections' : [ 'user', 'time', 'jobs', 'sys', 'venv', 'vcs',  'cwd', 'warn' ]}

let prompt_options = {
            \'left_sections' : [ 'user', 'jobs', 'cwd' ],
            \'right_sections' : [ 'warn', 'sys', 'venv', 'vcs', 'time' ],
            \'left_only_sections' : [ 'user', 'time', 'jobs', 'sys', 'venv', 'vcs', 'x',  'cwd', 'warn' ]}

let g:promptline_preset = {
            \'x'   : [ newline_slice ],
            \'user'   : [ myuser_slice, promptline#slices#host({ 'only_if_ssh': 0 }) ],
            \'jobs'   : [ promptline#slices#jobs() ],
            \'cwd'    : [ promptline#slices#cwd({ 'dir_limit': 3 }) ],
            \'sys'    : [ myuptime_slice ],
            \'venv'   : [ promptline#slices#python_virtualenv() ],
            \'vcs'    : [ promptline#slices#git_branch_status_sha() ],
            \'time'   : [ mydate_slice ],
            \'warn'   : [ promptline#slices#last_exit_code() ],
            \'options': prompt_options}

let g:promptline_symbols = {
            \ 'left'           : '',
            \ 'right'          : '',
            \ 'left_alt'       : '',
            \ 'right_alt'      : '',
            \ 'dir_sep'        : '  ',
            \ 'truncation'     : '⋯ ',
            \ 'vcs_branch'     : ''}

let g:promptline_multiline = 1

"" Digit2
"let g:promptline_symbols = {
            "\ 'left'           : ' ',
            "\ 'right'          : ' ',
            "\ 'left_alt'       : ' ' ,
            "\ 'right_alt'      : ' ' ,
            "\ 'dir_sep'        : '  ',
            "\ 'truncation'     : '⋯',
            "\ 'vcs_branch'     : ''}

"" Rounded
"let g:promptline_symbols = {
            "\ 'left'           : '',
            "\ 'right'          : '',
            "\ 'left_alt'       : '' ,
            "\ 'right_alt'      : '' ,
            "\ 'dir_sep'        : '  ',
            "\ 'truncation'     : '⋯',
            "\ 'vcs_branch'     : ' '}

" Fire
"let g:promptline_symbols = {
            "\ 'left'           : ' ',
            "\ 'right'          : ' ',
            "\ 'left_alt'       : ' ' ,
            "\ 'right_alt'      : ' ' ,
            "\ 'dir_sep'        : '  ',
            "\ 'truncation'     : ' ',
            "\ 'vcs_branch'     : ' '}

"" Digit
"let g:promptline_symbols = {
            "\ 'left'           : '',
            "\ 'right'          : '',
            "\ 'left_alt'       : '',
            "\ 'right_alt'      : '',
            "\ 'dir_sep'        : '  ',
            "\ 'truncation'     : '⋯',
            "\ 'vcs_branch'     : ' '}

