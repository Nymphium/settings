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
set listchars=tab:>_,trail:.,extends:>,precedes:<,nbsp:%,eol:<
set matchpairs& matchpairs+=<:>,（:）
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
set shell=/usr/bin/zsh
set clipboard+=unnamed,autoselect
set timeoutlen=250
set display=uhex

"" StatusLine settings
set statusline=[file:\"%t%m\"\|Type:\"%Y\"\|%{'Enc:\"'.(&fenc!=''?&fenc:&enc).'\"]'}\ %h%w\L%l\/%L\ %v
set laststatus=2

set splitright

set shellslash

" augroup CmdWithAlias
	" autocmd!
	" autocmd VimEnter * set shellcmdflag+=i
" augroup END
	
