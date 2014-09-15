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
NeoBundle 'Shougo/vinarise.vim'
NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }


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

	let g:quickrun_config['*'] = {
		\ 'outputter/buffer/close_on_empty' : 1 ,
	\ }

	let g:quickrun_config['tex'] = {
		\ 'command' : 'lpshow', 
		\ 'outputter/error/error' : 'quickfix',
	\ }
	let g:quickrun_config['cpp'] = {
		\ 'cmdopt': '-Wall -lm -march=native --std=c++11 -O3'
	\ }
	let g:quickrun_config['c'] = {
		\ 'cmdopt' : "-Wall -lm -march=native --std=c11 -O3"
	\ }
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
	let g:syntastic_check_on_open = 1
	let g:syntastic_loc_list_height = 3
	let g:syntastic_echo_current_error = 1
	let g:syntastic_enable_balloons = 1
	let g:syntastic_enable_highlighting = 1
	let g:syntastic_enable_signs=1
	let g:syntastic_auto_loc_list=2
	let g:syntastic_ignore_files = ['\.tex$']
	let g:syntastic_cpp_compiler = 'g++'
	let g:syntastic_cpp_compiler_options = '--std=c++11'
"" }

"" vinarise {
	augroup VinariseXXD
		autocmd!
		autocmd BufReadPre *.bin let &binary = 1
		autocmd BufReadPost * if &binary | silent Vinarise
		autocmd BufReadPost * endif
	augroup END
"" }
