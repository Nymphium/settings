runtime! archlinux.vim

filetype plugin indent on
syntax on

set fileencodings=utf-8
set fileformats=unix,dos,mac

set nobackup
set noswapfile

set grepprg=grep\ -nH\ $*
set nocompatible
set history=2000

set ignorecase
set smartcase
set hlsearch
set incsearch

set showmatch
set matchtime=2

set showcmd

set shiftwidth=4
set tabstop=4
set autoindent
set wrap

set scrolloff=20
set backspace=indent,eol,start
set list
" set listchars=tab:»-,trail:.,extends:»,precedes:«,nbsp:%,eol:↲
set listchars=tab:>_,trail:.,extends:>,precedes:<,nbsp:%,eol:<
set matchpairs& matchpairs+=<:>
set ambw=double
set wildmenu
set number
set relativenumber
set cursorcolumn
set cursorline
if &term =~ '256color'
	set t_ut=
endif
set t_Co=256
set lazyredraw
set shell=zsh
set clipboard=unnamedplus,autoselect,unmask
set timeoutlen=250
set display=uhex

"" StatusLine settings
set statusline=[Edit:\"%t%m\"\|Type:\"%Y\"\|%{'Enc:\"'.(&fenc!=''?&fenc:&enc).'\"]'}\ %h%w\L%l\/%L
set laststatus=2

"" KeyMappings
nmap <silent> <ESC> <ESC>:nohlsearch<CR>
nmap <ESC>a <ESC>:saveas 
nmap <ESC>s <Nop>
nmap <ESC>s <ESC>:w!<CR>
nmap <ESC>s<ESC>s <ESC>:wq!<CR>
nmap <ESC>w <Nop>
nmap <ESC>w<ESC>w <ESC>:q!<CR>
nmap V <C-v>
nmap <ESC>w <Nop>
nmap <ESC>C <Nop>
nmap <ESC>K <Nop>

vnoremap v $h
vnoremap L <Nop>
vnoremap H <Nop>
vnoremap W b
vnoremap E <Nop>
vnoremap E e
vnoremap <ESC>L $
vnoremap <ESC>H ^
vnoremap <ESC>j <C-d>
vnoremap <ESC>k <C-u>
vnoremap <TAB> >
vnoremap <S-Tab> <
vnoremap i I
vnoremap <ESC>z d<ESC>:let @z = "/*" . @" . "*/"<CR>"zp

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
nnoremap <silent> <F3> :setlocal relativenumber!<CR>
nnoremap I <Nop>
nnoremap II :let l=line(".")<CR>:let c=col(".")<CR><ESC>gg=G:call cursor(l,c)<CR>
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
nnoremap <ESC>o <Nop>
nnoremap <ESC>o o<ESC>

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
inoremap <ESC>s <Nop>
inoremap <ESC>s <ESC>:w<CR>i
inoremap <ESC>u <ESC>ui
inoremap <ESC>p <ESC>pi
inoremap <ESC>d <ESC>ddi
inoremap <silent> <ESC>e <ESC>:nohlsearch<CR>
inoremap L <Nop>
inoremap L L
inoremap H <Nop>
inoremap H H
inoremap <ESC>L <End>
inoremap <ESC>H <Home>
inoremap <C-w> <Nop>
inoremap <C-w><C-w> <ESC><ESC>:q!<CR>
inoremap <ESC>f <ESC><ESC>/
inoremap <ESC>a <ESC>:saveas <Space>
inoremap <S-Tab> <ESC><ESC><<i
inoremap <C-q> <ESC>:q!<CR>

"" edit binary by run: %vim -b filename
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre *.bin let &binary = 1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufReadPre * if &binary | silent %!xxd -r | endif
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set nomod | endif
augroup END

augroup SyntaxProlog
	autocmd!
	autocmd BufNewFile *.swi set filetype=prolog
	autocmd BufReadPost *.swi set filetype=prolog
augroup END

let g:tex_flavor = "latex"
let php_parent_error_close = 1
let php_parent_error_open = 1
let java_highlight_all = 1
let java_highlight_debug = 1
let java_highlight_functions = 1

augroup LatexSub
	autocmd!
	autocmd BufWritePre *.tex silent :%s/｡/。/ge
	autocmd BufWritePre *.tex silent :%s/､/、/ge
	autocmd BufWritePre *.tex silent :%s/｢\(.*\)｣/「\1」/ge
	autocmd BufWritePre *.tex silent :%s/(\(.*\))/（\1）/ge
augroup END

function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
				\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
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

"" insertmode highlight {
let g:hi_insert = 'highlight StatusLine cterm=reverse,bold ctermfg=4 ctermbg=3'

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

	NeoBundle "vim-scripts/rdark"
	NeoBundle 'osyo-manga/vim-over'
	NeoBundle "Shougo/neocomplete.vim"
	NeoBundle "othree/eregex.vim"
	NeoBundle "scrooloose/nerdcommenter"
	NeoBundle "Shougo/neosnippet"
	NeoBundle "othree/html5.vim"
	NeoBundle "Townk/vim-autoclose"
	NeoBundle "thinca/vim-quickrun"
	NeoBundle "tpope/vim-surround"
	NeoBundle 'Markdown'
	NeoBundle 'suan/vim-instant-markdown'
	NeoBundle 'tpope/vim-endwise'
	NeoBundle 'tpope/vim-pathogen'
	NeoBundle 'scrooloose/syntastic'
	NeoBundle 'rkitover/vimpager'
	NeoBundle 'adimit/prolog.vim'
"" }

"" ----plugins' settings & keymaps----{
	 "" eregex {
		 nmap <ESC>f <Nop>
		 nmap <ESC>f <ESC>:M/
	"" }

	"" NERDCommenter {
		"" the number of space adding when commenting
		let NERDSpaceDelims = 1
		nmap <ESC>C <Nop>
		nmap <ESC>C <Plug>NERDCommenterToggle
		vmap <ESC>C <Nop>
		vmap <ESC>C <Plug>NERDCommenterToggle
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

		inoremap <ESC>C <Nop>
		inoremap <expr><ESC>C neocomplete#undo_completion()
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

		"" For cursor moving in insert mode(Not recommended)
		inoremap <expr><ESC>h neocomplete#close_popup() . "\<Left>"
		inoremap <expr><ESC>l neocomplete#close_popup() . "\<Right>"
		inoremap <expr><ESC>k neocomplete#close_popup() . "\<Up>"
		inoremap <expr><ESC>j neocomplete#close_popup() . "\<Down>"

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
	"" }

	"" vim-over {
		nnoremap <silent> %% :OverCommandLine<CR>%S/
		nnoremap <silent> %P y:OverCommandLine<CR>%S!<C-r>=substitute(@0, '!', '\\!','g')<CR>!!gI<Left><Left><Left>
	"" }

	"" vim-quickrun {
		let g:quickrun_config = {}
		let g:quickrun_config['tex'] = {'command' : 'lpshow'}
		let g:quickrun_config['prolog'] = {'command' : 'gprolog'}
	"" }

	"" surround {
		xmap " <Plug>VSurround"
		xmap ' <Plug>VSurround'
		xmap ( <Plug>VSurround)
		xmap { <Plug>VSurround}
		xmap < <Plug>VSurround>
		xmap [ <Plug>VSurround]
	"" }

	"" vim-pathogen {
		call pathogen#infect()
	"" }

	"" syntastic {
		let g:syntastic_enable_signs=1
		let g:syntastic_auto_loc_list=2
	"" }
"" }

"" ----color setting---- {
	colorscheme rdark
	hi CursorLine cterm=bold ctermbg=234
	hi CursorColumn ctermbg=234
	hi Comment ctermfg=255 ctermbg=237
	hi SpecialKey ctermfg=240
	hi LineNr cterm=bold ctermfg=246 ctermbg=232
	hi StatusLine ctermfg=0 ctermbg=255 cterm=bold
	hi Special cterm=bold ctermfg=204
	hi PreProc cterm=bold
	hi Type cterm=bold ctermfg=47
	hi String cterm=bold ctermfg=206
	hi Statement cterm=bold
	hi Constant cterm=bold
"" }

"" ----kill lasting comment function when starting a new line---- {
autocmd Filetype * set formatoptions-=ro
"" }
