"" make block comment
function! CommentInLine()
	normal `<i/* 

	normal `>3la */
endfunction

vnoremap <ESC>z <ESC>:call CommentInLine()<CR>

"" highlighting program as Prolog {
	augroup SyntaxProlog
		autocmd!
		autocmd BufNewFile *.swi set filetype=prolog
		autocmd BufReadPost *.swi set filetype=prolog
	augroup END
"" }

	let g:tex_flavor = "latex"
	let php_parent_error_close = 1
	let php_parent_error_open = 1
	let java_highlight_all = 1
	let java_highlight_debug = 1
	let java_highlight_functions = 1

"" substitute TeX file {
	augroup LatexSub
		autocmd!
		autocmd BufWritePre *.tex silent :%s/｡/。/ge
		autocmd BufWritePre *.tex silent :%s/､/、/ge
		autocmd BufWritePre *.tex silent :%s/｢/「/ge
		autocmd BufWritePre *.tex silent :%s/｣/」/ge
		" autocmd BufWritePre *.tex silent :%s/\([lL][eE][fF][tT]\)\@<!(/（/ge
		" autocmd BufWritePre *.tex silent :%s/\([rR][iI][gG][hH][tT]\)\@<!)/）/ge
	augroup END
"" }

"" highlight Zenkaku-space {
	function! ZenkakuSpace()
		hi ZenkakuSpace cterm=underline ctermbg=196 gui=underline guifg=darkgrey
	endfunction

	if has('syntax')
		augroup ZenkakuSpace
			autocmd!
			autocmd ColorScheme       * call ZenkakuSpace()
			autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
		augroup END

		call ZenkakuSpace()
	endif
"" }

"" insertmode highlight {
	let g:hi_insert = 'highlight StatusLine cterm=reverse,bold ctermfg=0 ctermbg=255'

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

