set nocompatible               " be iMproved
filetype off                   " required!

let g:devel = 0
let g:has_gui = get(g:, 'has_gui', 0)

function! IfCond(cond, ...) " {{{
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
" }}}

call plug#begin('~/.local/share/nvim/plugged')

" My Bundles here:
"
" original repos on github {{{
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }
Plug 'jlanzarotta/bufexplorer'
Plug 'vim-airline/vim-airline', { 'commit': 'a6dd1c3' }
Plug 'vim-airline/vim-airline-themes'
" Plug 'bling/vim-bufferline'
Plug 'sk1418/Join'
Plug 'Townk/vim-autoclose'
Plug 'cespare/vim-toml'
Plug 'vito-c/jq.vim'
Plug 'sbdchd/neoformat', { 'on': 'Neoformat' }
Plug 'psf/black', { 'branch': 'stable', 'on': 'Black' }
Plug 'WolfgangMehner/bash-support'
" TODO: Missing dependency : nodejs
" Plug 'maksimr/vim-jsbeautify'
" }}}
" Colorschemes {{{
Plug 'drewtempelmeyer/palenight.vim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Plug 'dracula/vim'
" Plug 'morhetz/gruvbox'
" Plug 'ayu-theme/ayu-vim'
" let ayucolor="dark"
" Plug 'wadackel/vim-dogrun'
" Plug 'jacoborus/tender.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'nanotech/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'nightsense/cosmic_latte'
Plug 'chriskempson/base16-vim'
" }}}
" Completion {{{
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/deoplete.nvim', IfCond(g:devel, { 'do': ':UpdateRemotePlugins' })
" }}}
" Linting {{{
Plug 'neomake/neomake', IfCond(g:devel)
" }}}
" Devel {{{
Plug 'fatih/vim-go', IfCond(g:devel)
Plug 'Shougo/neosnippet.vim', IfCond(g:devel)
Plug 'Shougo/neosnippet-snippets', IfCond(g:devel)
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets', IfCond(g:devel)
Plug 'deoplete-plugins/deoplete-jedi', IfCond(g:devel)
" Plug 'davidhalter/jedi-vim', IfCond(g:devel)
" }}}
" Icons {{{
Plug 'ryanoasis/vim-devicons', IfCond(g:has_gui)
" }}}
" Initialize plugin system
call plug#end()

" Install plugins
" :PlugInstall [name ...] [#threads]
" Install or update plugins
" :PlugUpdate [name ...] [#threads]
" Remove unlisted plugins (bang version will clean without prompt)
" :PlugClean[!]
" Upgrade vim-plug itself
" :PlugUpgrade
" Check the status of plugins
" :PlugStatus
" Examine changes from the previous update and the pending changes
" :PlugDiff
" Generate script for restoring the current snapshot of the plugins
" :PlugSnapshot[!] [output path]

" Put your non-Plugin stuff after this line

" set omnifunc=syntaxcomplete#Complete
set cot=menuone

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'
let g:loaded_python_provider = 0

" ----------------------------------------------------------------------------
" The following section contains suggested settings.  While in no way required
" to meet coding standards, they are helpful.

" Set the default file encoding to UTF-8: ``set encoding=utf-8``
set encoding=utf-8
" For syntax highlighting:
syntax on
" Automatically indent based on file type: ``filetype indent on``
" Keep indentation level from previous line: ``set autoindent``
"filetype plugin indent on
set autoindent
" Folding based on indentation: ``set foldmethod=indent``
" set foldmethod=indent

" => VIM user interface{{{
set cmdheight=3 "The commandbar height
set hid "Change buffer - without saving
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
"Ignore case when searching
set ignorecase
set smartcase
set number
set title
set mousemodel=popup
"}}}
" => Statusline{{{
" Always hide the statusline
set laststatus=2
" Format the statusline
function! CurDir()
	let curdir = substitute(getcwd(), '/home/canalguada/', "~/", "g")
	return curdir
endfunction

function! HasPaste()
	if &paste
		return 'PASTE MODE  '
	else
		return ''
	endif
endfunction
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c
"}}}
" => Colors and Fonts {{{
set background=dark
let g:material_theme_style = 'palenight'
let g:material_terminal_italics = 1
let g:palenight_terminal_italics=1
" Alternatives: Tomorrow-Night-Eighties, gruvbox, jellybeans, onehalfdark, material
" colorscheme default
colorscheme jellybeans

" }}}
" => Airline {{{
set noshowmode
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
"let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = ''
" let g:airline#extensions#bufferline#enabled = 1
" let g:airline#extensions#bufferline#overwrite_variables = 1

" autocmd! BufWritePost ~/.config/nvim/ginit.vim execute ':AirlineRefresh'
" }}}
" => Bufferline {{{
" let g:bufferline_echo = 1
" let g:bufferline_active_buffer_left = '['
" let g:bufferline_active_buffer_right = ']'
" let g:bufferline_modified = '+'
" let g:bufferline_show_bufnr = 1


" let g:bufferline_echo = 0
" autocmd vimenter *
"       \ let &statusline='%{bufferline#refresh_status()}'
"       \ .bufferline#get_status_string()
" }}}
" => Powerline {{{
" let g:powerline_pycmd = 'py3'
" }}}
" => General{{{
set shell=/bin/bash
set history=700 "Sets how many lines of history VIM has to remember
set autoread " Set to auto read when a file is changed from the outside
set hlsearch "Highlight search things
set magic "Set magic on, for regular expressions
set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink
set smarttab
set cc=+1
setlocal softtabstop=4
setglobal modeline
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[1 q"
set timeoutlen=1000 ttimeoutlen=10
" When vimrc is edited, reload it {{{
autocmd! BufWritePost ~/.config/nvim/init.vim nested
			\ :source ~/.config/nvim/init.vim
autocmd! BufWritePost ~/.config/nvim/ginit.vim nested
			\ :source ~/.config/nvim/ginit.vim
" }}}
" Map leader {{{
let mapleader = ","
let g:mapleader = ","
" }}}
" Toggle the quickfix window {{{
" From Steve Losh, http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
nnoremap <C-q> :call <SID>QuickfixToggle()<cr>
let g:quickfix_is_open = 0
function! s:QuickfixToggle()
	if g:quickfix_is_open
		cclose
		let g:quickfix_is_open = 0
		execute g:quickfix_return_to_window . "wincmd w"
	else
		let g:quickfix_return_to_window = winnr()
		copen
		let g:quickfix_is_open = 1
	endif
endfunction
" }}}
" }}}
" => Command mode related {{{
" Fast saving
nmap <leader>w :w!<cr>
" Fast editing of the init.vim
map <leader>e :e! ~/.config/nvim/init.vim<cr>
map <leader>ev :split ~/.config/nvim/basic_init.vim<cr>
" Smart mappings on the command line
cno $h  ~/
cno $s  ~/Scripts/
cno $f  ~/.config/
cno $g  ~/git/canalguada/
cno $l  ~/.local/
cno $p  ~/Projects/
cno $y  ~/PycharmProjects/
cno $j  ./
cno $z  ~/.zsh/
cno $c  <C-\>eCurrentFileDir("e")<cr>
func! CurrentFileDir(cmd)
	return a:cmd . " " . expand("%:p:h") . "/"
endfunc
" }}}
" => Visual mode related {{{
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
function! CmdLine(str) " {{{
	exe "menu Foo.Bar :" . a:str
	emenu Foo.Bar
	unmenu Foo
endfunction
" }}}
function! VisualSearch(direction) range " {{{
	" From an idea by Michael Naumann
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	elseif a:direction == 'gv'
		call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction
" }}}
" }}}
" => Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
" set foldmethod=indent   " fold based on indent level
" Toggle the foldcolumn {{{
nnoremap <leader>f :call FoldColumnToggle()<cr>
let g:last_fold_column_width = 4  " Pick a sane default for the foldcolumn
function! FoldColumnToggle()
	if &foldcolumn
		let g:last_fold_column_width = &foldcolumn
		setlocal foldcolumn=0
	else
		let &l:foldcolumn = g:last_fold_column_width
	endif
endfunction
" }}}
" }}}
" => Editing mappings {{{
" Remap VIM 0
map 0 ^
" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac {{{
" nmap <M-j> mz:m+<cr>`z
" nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
" }}}
" func! DeleteTrailingWS() " {{{
"   exe "normal mz"
"   %s/\s\+$//ge
"   exe "normal `z"
" endfunc
" autocmd BufWrite *.py :call DeleteTrailingWS()
" }}}
set guitablabel=%t
" }}}
" => Moving around, tabs and buffers {{{
map <silent> <leader><cr> :noh<cr>
" Map space to / (search) and c-space to ? (backgwards search) {{{
"map <space> /
"map <c-space> ?
" }}}
" Smart way to move btw. windows {{{
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" }}}
" Tab configuration {{{
map <leader>tn :tabnew<CR>
map <leader>te :tabedit
map <leader>tc :tabclose<CR>
map <leader>tm :tabmove
map <leader>tt :tabnext<CR>
map <leader>tp :tabprevious<CR>
" }}}
" Be able to move between the tabs with ALT+LeftArrow and ALT+RightArrow {{{
map <silent><A-Right> :tabnext<CR>
map <silent><A-Left> :tabprevious<CR>
" }}}
" When pressing <leader>cd switch to the directory of the open buffer {{{
map <leader>cd :cd %:p:h<cr>
" }}}
" Closing buffers {{{
" only the current buffer
" map <leader>bd :Bclose<CR>:tabclose<CR>
" all the buffers
" map <leader>ba :1,300 bd!<cr>
map <leader>ba :bufdo! bdelete<cr>
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt() " {{{
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")
	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif
	if bufnr("%") == l:currentBufNum
		new
	endif
	if buflisted(l:currentBufNum)
		execute("bdelete! ".l:currentBufNum)
	endif
endfunction
" }}}
" }}}
" Open every buffer in its own tabpage {{{
" function! OpenArgumentsInTabs()
"   ardo tabedit
"   if tabpagenr("$") > 1
"     tabclose
"   endif
" endfunction
" autocmd VimEnter * call OpenArgumentsInTabs()
" }}}
" }}}
" => General Abbrevs {{{
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
" }}}
" => Mutt {{{
au BufRead /tmp/mutt-* set tw=72
" }}}
" => Python section {{{
" Bindings {{{
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self
au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def
" }}}
" Code Completion {{{
autocmd FileType python set omnifunc=pythoncomplete#Complete
inoremap <Nul> <C-x><C-o>
" }}}
" Documentation {{{
" Using :Pydoc os.path and :PydocSearch word (or \pw and \pW)
let g:pydoc_cmd = "/usr/bin/pydoc"
" }}}
" Syntax Checking {{{
" autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
" autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" }}}
" <F5> is mapped to execute the current script (python2 version).
autocmd BufRead *.py nmap <F5> :!~/bin/Terminal -p python2 %<CR>
" <F6> is mapped to execute the current script (python3 version).
autocmd BufRead *.py nmap <F6> :!~/bin/Terminal -p python3 %<CR>
" }}}
" => Others {{{
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <CR> :noh<CR><CR>
let @/ = ""
" }}}
" => NERDCommenter {{{
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" }}}
" => Tagbar {{{
" You can now use the ":TagbarToggle" command to open/close the taglist window.
" F4: Switch on/off TagBar
" nnoremap <silent> <F4> :TagbarToggle<CR>
nnoremap <silent> <F4> :TagbarOpenAutoClose<CR>
let g:tagbar_usearrows = 1
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
" }}}
" => BufExplorer {{{
" nnoremap <leader>l :BufExplorer<CR>
nnoremap <leader>be :BufExplorer<CR>
" }}}
" => Command-T {{{
" nnoremap <leader>l :CommandTBuffer<CR>
" let g:CommandTFileScanner = 'find'
" let g:CommandTMaxFiles=500
" let g:CommandTMaxDepth=2
" let g:CommandTAlwaysShowDotFiles=1
" }}}
" => NerdTree - NerdTreeTabs {{{
"autocmd vimenter * if !argc() | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nw :NERDTreeCWD<CR>
nmap <F2> :NERDTreeCWD<CR>
nmap <F3> :NERDTreeToggle<CR>
nmap <F12> :NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_gui_startup = 2
" }}}
" => PrettyXML {{{
function! DoPrettyXML() " {{{
	" save the filetype so we can restore it later
	let l:origft = &ft
	set ft=
	" delete the xml header if it exists. This will
	" permit us to surround the document with fake tags
	" without creating invalid xml.
	1s/<?xml .*?>//e
	" insert fake tags around the entire document.
	" This will permit us to pretty-format excerpts of
	" XML that may contain multiple top-level elements.
	0put ='<PrettyXML>'
	$put ='</PrettyXML>'
	silent %!xmllint --format -
	" xmllint will insert an <?xml?> header. it's easy enough to delete
	" if you don't want it.
	" delete the fake tags
	2d
	$d
	" restore the 'normal' indentation, which is one extra level
	" too deep due to the extra tags we wrapped around the document.
	silent %<
	" back to home
	1
	" restore the filetype
	exe "set ft=" . l:origft
endfunction
" }}}
command! PrettyXML call DoPrettyXML()
" }}}
" => Modeline {{{
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ft=%s fdm=%s ts=%d sw=%d tw=%d %s:",
		\ &filetype, &foldmethod, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'noet')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
" }}}
" => Copy and paste {{{
" primary
vnoremap <silent><C-Insert> "*y
vnoremap <silent><S-Delete> "*d
vnoremap <silent><S-Insert> x<left>"*p
nnoremap <silent><S-Insert> "*p
inoremap <silent><S-Insert> <C-R>*
" clipboard
vnoremap <silent><C-S-c> "+y
vnoremap <silent><C-S-x> "+d
vnoremap <silent><C-S-v> x<left>"+p
nnoremap <silent><C-S-v> "+p
inoremap <silent><C-S-v> <C-R>+
" }}}
" => Deoplete {{{
" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
autocmd InsertEnter * call deoplete#enable()

let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#python_path = '/usr/bin/python3'
let g:deoplete#sources#jedi#extra_path = [
			\ '/home/canalguada/PycharmProjects/cglibrary',
			\ '/home/canalguada/.local/lib/python3.9/site-packages',
			\ ]

call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" As per https://github.com/Shougo/deoplete.nvim/issues/989
" inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}
" => Autoformat {{{
" "autocmd FileType vim,tex let b:autoformat_autoindent=0
" let g:autoformat_autoindent = 0
" let g:autoformat_retab = 0
" let g:autoformat_remove_trailing_spaces = 0
" au BufWrite * :Autoformat
"
" let g:autoformat_verbosemode=0
" let g:formatterpath = ['/home/canalguada/.local/bin']
" }}}
" => Neoformat {{{
let g:neoformat_enabled_python = ['black']
let g:shfmt_opt="-ci -p -kp"
" Enable alignment
let g:neoformat_basic_format_align = 0
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 0
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
" Quiet
let g:neoformat_only_msg_on_error = 1
" When use Neoformat
" augroup fmt
"   autocmd!
"   autocmd BufWritePre * undojoin | Neoformat
" augroup END
nnoremap <leader>ff :Neoformat<CR>
" }}}
" => Black {{{
" let g:black_fast = 0
let g:black_linelength = 80
" let g:black_skip_string_normalization = 0
let g:black_virtualenv = '~/.venvs/black'
"autocmd BufWritePre *.py execute ':Black'
nnoremap <F9> :Black<CR>
" }}}
" => Bash Support {{{
" let g:BASH_OutputGvim = "xterm"
" let g:BASH_XtermDefaults = "-fa Hack -fs 9 -geometry 117x32"
let g:BASH_OutputMethod = "terminal"
let g:BASH_MapLeader  = ';'
" }}}
" => Terminal {{{
tnoremap <Esc>e <C-\><C-n>
" }}}
" => Navigation {{{
" To use `ALT+{h,j,k,l}` to navigate windows from any mode:
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" }}}

if g:devel
	" => Jedi {{{
	" let g:jedi#force_py_version = 3
	" let g:jedi#show_call_signatures = "1"
	" let g:jedi#goto_command = "<leader>d"
	" let g:jedi#goto_assignments_command = "<leader>g"
	" let g:jedi#goto_definitions_command = ""
	" let g:jedi#documentation_command = "<leader>k"
	" let g:jedi#usages_command = "<leader>u"
	" let g:jedi#completions_command = ""
	" let g:jedi#rename_command = "<leader>r"
	" let g:jedi#use_tabs_not_buffers = 1
	" let g:jedi#completions_enabled = 0
	" }}}
	" => Neosnippet {{{
	" Tell Neosnippet about the other snippets
	let g:neosnippet#snippets_directory=[
				\ '~/.local/share/nvim/plugged/vim-snippets/snippets/',
				\ '~/.config/nvim/snippets/',
				\ ]
	" Plugin key-mappings.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	" SuperTab like snippets behavior.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	"imap <expr><TAB>
	" \ pumvisible() ? "\<C-n>" :
	" \ neosnippet#expandable_or_jumpable() ?
	" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
				\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	" For conceal markers.
	if has('conceal')
		set conceallevel=2 concealcursor=niv
	endif
	" }}}
	" => Neomake {{{
	" When writing a buffer.
	"call neomake#configure#automake('w')
	" When writing a buffer, and on normal mode changes (after 750ms).
	"call neomake#configure#automake('nw', 750)
	" When reading a buffer (after 1s), and when writing.
	"call neomake#configure#automake('rw', 1000)
	let g:neomake_open_list = 2
	let g:neomake_list_height = 10
	"let g:neomake_python_enabled_makers = ['pep8', 'pylint', 'pyflakes']
	let g:neomake_python_enabled_makers = ['pylint']
	"let g:neomake_sh_enabled_makers = ['shellcheck']
	let g:neomake_sh_enabled_makers = []
	autocmd VimEnter * NeomakeDisable
	" }}}
endif

" Opening and closing folds
"The command zc will close a fold (if the cursor is in an open fold), and
"zo will open a fold (if the cursor is in a closed fold). It's easier to
"just use za which will toggle the current fold (close it if it was open,
"or open it if it was closed).

"The commands zc (close), zo (open), and za (toggle) operate on one level of
"folding, at the cursor. The commands zC, zO and zA are similar, but operate
"on all folding levels (for example, the cursor line may be in an open fold,
"which is inside another open fold; typing zC would close all folds at the
"cursor).

"The command zr reduces folding by opening one more level of folds throughout
"the whole buffer (the cursor position is not relevant). Use zR to open all folds.
"The command zm gives more folding by closing one more level of folds
"throughout the whole buffer. Use zM to close all folds.

" vim: set ft=vim fdm=marker ai ts=2 sw=2 tw=79 noet:
