runtime! archlinux.vim

filetype plugin indent on
syntax on

set grepprg=grep\ -nH\ $*
set clipboard+=unnamed
set clipboard+=autoselect
set nocompatible
set fileencodings=iso-2022-jp,sjis,euc-jp,utf-8
set fileformats=unix,dos
set history=2000
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
set matchtime=1
set showcmd
set shiftwidth=4
set tabstop=4
set scrolloff=20
set nobackup
set noswapfile
set backspace=indent,eol,start
set list
set listchars=tab:»-,trail:.,extends:»,precedes:«,nbsp:%,eol:↲
set wrap
set number
set autoindent
set ruler
set matchpairs& matchpairs+=<:>
set fileformats=unix,dos,mac
set ambiwidth=double
set wildmenu
set wildmode=list,full
set cursorcolumn
set cursorline
set t_Co=256
set relativenumber
set lazyredraw
set statusline+=%r
set shell=zsh

"" KeyMappings
nmap <silent> <ESC>e <ESC>:nohlsearch<CR>
nmap <ESC>t<ESC>l <ESC>:tabn
nmap <ESC>t<ESC>h <ESC>:tabp
nmap e <Nop>
nmap <ESC>a <Nop>
nmap <ESC>a <ESC>:saveas <Space>
nmap <ESC>s <Nop>
nmap <ESC>s <ESC>:w<CR>
nmap <ESC>s<ESC>s <ESC>:x<CR>
nmap V <Nop>
nmap V <C-v>
nmap <C-w> <Nop>
nmap <ESC>c <Nop>
nmap <ESC>k <Nop>

vnoremap v $h
vnoremap L <Nop>
vnoremap H <Nop>
vnoremap <ESC>L $
vnoremap <ESC>H ^
vnoremap <ESC>j <C-d>
vnoremap <ESC>k <C-u>
vnoremap <TAB> >
vnoremap <S-Tab> <
"" toggle /*comment*/ (unfinished)
vnoremap <silent> <ESC>z "qdi/**/<left><left><ESC><ESC>"qp

nnoremap <BS> X
nnoremap <ESC>1 <C-x>
nnoremap <ESC>2 <C-a>
nnoremap j gj
nnoremap k gk
nnoremap E <Nop>
nnoremap E w
nnoremap W <Nop>
nnoremap W b
nnoremap p "0p
nnoremap P "1p
nnoremap r <C-r>
nnoremap L <Nop>
nnoremap H <Nop>
nnoremap <ESC>L $
nnoremap <ESC>H ^
nnoremap <ESC>j <C-d>
nnoremap <ESC>k <C-u>
nnoremap <ESC>s <Nop>
nnoremap <ESC>s <ESC>:w<CR>
nnoremap <ESC>s<ESC>s <ESC>:x<CR>
nnoremap <C-w> <Nop>
nnoremap <C-W><C-W> <ESC>:q!<CR>
nnoremap <silent> <F3> :setlocal relativenumber!<CR>
nnoremap I <Nop>
nnoremap II <ESC>gg=G
nnoremap ww <ESC>:vne<Space>
nnoremap wv <ESC>:new<Space>
nnoremap w<TAB> <C-w>w
nnoremap wl <ESC><C-w><<C-w><<C-w><<C-w><<C-w><
nnoremap wh <ESC><C-w>><C-w>><C-w>><C-w>><C-w>>
nnoremap wj <ESC><C-w>+<C-w>+<C-w>+<C-w>+<C-w>+
nnoremap wk <ESC><C-w>-<C-w>-<C-w>-<C-w>-<C-w>-
nnoremap <return> <ESC>i<return><ESC>
nnoremap <TAB> >>
nnoremap <S-Tab> <<

inoremap <ESC>v <Nop>
inoremap <ESC>v <ESC>"*pa
inoremap <ESC>1 <Nop>
inoremap <ESC>2 <Nop>
inoremap <ESC>1 <ESC><C-x>i
inoremap <ESC>2 <ESC><C-a>i
inoremap <ESC>j <Down>
inoremap <ESC>k <Up>
inoremap <ESC>h <Left>
inoremap <ESC>l <Right>
inoremap <silent> <ESC>e <ESC><ESC>:nohlsearch<CR>
inoremap <ESC>s <Nop>
inoremap <ESC>s <ESC>:w<CR>i
inoremap <ESC>u <ESC>ui
inoremap <ESC>p <ESC>pi
inoremap <ESC>d <ESC>ddi
inoremap L <Nop>
inoremap L L
inoremap H <Nop>
inoremap H H
inoremap <ESC>L <End>
inoremap <ESC>H <Home>
inoremap <C-w> <Nop>
inoremap <C-w><C-w> <ESC><ESC>:q!<CR>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap <ESC>f <ESC><ESC>/
inoremap <ESC>a <ESC>:saveas <Space>
"" inoremap <S-Tab> <ESC>>><<<<i
inoremap <C-q> <ESC>:q!<CR>

"" You can edit binary by run: %vim -b filename
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre *.bin let &binary = 1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufReadPre * if &binary | silent %!xxd -r | endif
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set nomod | endif
augroup END

let g:tex_flavor = "latex"
let php_parent_error_close = 1
let php_parent_error_open = 1
let java_highlight_all = 1
let java_highlight_debug = 1
let java_highlight_functions = 1

function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
				\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction

"" autoconfirm character-code
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	unlet s:enc_euc
	unlet s:enc_jis
endif

if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif

function! s:SID_PREFIX()
	return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

"" highlight Zenkaku-space {

function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction

if has('syntax')
	augroup ZenkakuSpace
		autocmd!
		autocmd ColorScheme       * call ZenkakuSpace()
		"" how to highlight Zenkaku-space
		autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
	augroup END
	call ZenkakuSpace()
endif
"" }

"" Set tabline.{
function! s:my_tabline()
	let s = ''
	for i in range(1, tabpagenr('$'))
		let bufnrs = tabpagebuflist(i)
		"" first window, first appears
		let bufnr = bufnrs[tabpagewinnr(i) - 1]
		"" display 0-origin tabpagenr.
		let no = i
		let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
		let title = fnamemodify(bufname(bufnr), ':t')
		let title = '' . title . ' |'
		let s .= '%'.i.'T'
		let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
		let s .= no . '- ' . title
		let s .= mod
		let s .= '%#TabLineFill# '
	endfor
	let s .= '%#TabLineFill#%T%=%#TabLine#'
	return s
endfunction

let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2
"" }

"" insertmode highlight {
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction
"" }

"" -----NeoBundle----- {
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#rc('~/.vim/bundle')
	filetype plugin on
	filetype indent on
endif

NeoBundle "gmarik/vundle"
NeoBundle "rails.vim"
NeoBundle 'osyo-manga/vim-over'
NeoBundle "tpope/vim-fugitive"
NeoBundle "git://github.com/vim-scripts/Align"
NeoBundle "git://github.com/Shougo/neocomplete.vim"
NeoBundle "git://github.com/othree/eregex.vim"
NeoBundle "git://github.com/scrooloose/nerdcommenter"
NeoBundle "git://github.com/vim-scripts/rdark"
NeoBundle "git://github.com/Shougo/neosnippet"
NeoBundle "othree/html5.vim"
NeoBundle "https://github.com/h1mesuke/vim-alignta"
NeoBundle "https://github.com/scrooloose/syntastic"

"" ----plugins' settings & plugins' keymaps----{
	 "" ergex {
		 nmap <ESC>f <Nop>
		 nmap <ESC>f <ESC>:M/
	"" }

	"" NERDCommenter {
		let NERDSpaceDelims = 1
		nmap <ESC>c <Nop>
		nmap <ESC>c <Plug>NERDCommenterToggle
		vmap <ESC>c <Plug>NERDCommenterToggle
	""}


	"" neocomplete {
		"" Disable AutoComplPop.
		let g:acp_enableAtStartup = 0
		"" Use neocomplete.
		let g:neocomplete#enable_at_startup = 1
		"" Use smartcase.
		let g:neocomplete#enable_smart_case = 1
		"" Set minimum syntax keyword length.
		let g:neocomplete#sources#syntax#min_keyword_length = 1
		let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

		"" Define dictionary.
		let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
		\ }

		"" Define keyword.
		if !exists('g:neocomplete#keyword_patterns')
			let g:neocomplete#keyword_patterns = {}
		endif
		let g:neocomplete#keyword_patterns['default'] = '\h\w*'

		inoremap <ESC>c <Nop>
		inoremap <expr><ESC>c neocomplete#undo_completion()
		inoremap <expr><C-l> neocomplete#complete_common_string()

		"" <CR>: close popup and save indent.
		inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

		function! s:my_cr_function()
		  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
		endfunction

		"" <TAB>: completion.
		inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
		inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
		"" <C-h>, <BS>: close popup and delete backword char.
		inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
		inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
		inoremap <expr><C-y> neocomplete#close_popup()
		inoremap <expr><ESC>z neocomplete#cancel_popup()
		"" Close popup by <Space>.
		"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

		"" For cursor moving in insert mode(Not recommended)
		inoremap <expr><ESC>h neocomplete#close_popup() . "\<Left>"
		inoremap <expr><ESC>l neocomplete#close_popup() . "\<Right>"
		inoremap <expr><ESC>k neocomplete#close_popup() . "\<Up>"
		inoremap <expr><ESC>j neocomplete#close_popup() . "\<Down>"
		"" Or set this.
		"" let g:neocomplete#enable_cursor_hold_i = 1
		"" Or set this.
		"" let g:neocomplete#enable_insert_char_pre = 1


		"" AutoComplPop like behavior.
		"" let g:neocomplete#enable_auto_select = 1

		"" Shell like behavior(not recommended).
		"" set completeopt+=longest
		"" let g:neocomplete#enable_auto_select = 1
		"" let g:neocomplete#disable_auto_complete = 1
		"" inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

		"" Enable omni completion.
		autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
		autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
		autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
		autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
		autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
		autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

		"" Enable heavy omni completion.
		if !exists('g:neocomplete#sources#omni#input_patterns')
		  let g:neocomplete#sources#omni#input_patterns = {}
		endif
		let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
		let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
		let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

		"" For perlomni.vim setting.
		"" https://github.com/c9s/perlomni.vim
		let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
	"" }

	"" vim-over {
		nnoremap <silent> %% :OverCommandLine<CR>%s/
		nnoremap <silent> %P y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!','g')<CR>!!gI<Left><Left><Left>
	"" }

	"" }
"" }


"" ----color setting---- {
	colorscheme rdark
	hi cursorline term=reverse cterm=none ctermbg=232
	hi cursorcolumn ctermbg=232
	hi Comment ctermfg=LightCyan cterm=italic
	hi SpecialKey term=underline ctermfg=darkgray guifg=#1a1a1a
	hi LineNr cterm=none ctermfg=white ctermbg=234

	"" colorselect GBA(GUI, relying xfce...??)
	noremap <silent> <F5> <ESC>:ColorSelect<CR>

"" }

"" ----ikill lasting comment function when starting a new line---- {
autocmd Filetype * set formatoptions-=ro
"" }
