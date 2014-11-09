hi ocamlKeyword cterm=bold ctermfg=226
hi ocamlKeyChar cterm=bold ctermfg=47
hi ocamlFunc cterm=bold ctermfg=81
hi ocamlIf cterm=bold ctermfg=48
hi ocamlDoubleSemicolon cterm=bold ctermfg=48
hi link ocamlArrow ocamlKeyword
hi link ocamlSymbol ocamlIf

augroup OCamlSntax
	autocmd!
	autocmd VimEnter *.ml syn match ocamlKeyword "\(\s\+\)\@<=to\(\s\+\)\@="
	autocmd VimEnter *.ml syn match ocamlDoubleSemicolon "\<;;\>"
	autocmd VimEnter *.ml syn match ocamlFunc "\(\<let\s\+\(rec\s\+\)\{0,1\}\)\@<=\w\+\>"
	autocmd VimEnter *.ml syn match ocamlFunc "\(\<and\s\+\)\@<=\w\+\>"
	autocmd VimEnter *.ml syn match ocamlFunc "\<print_\h\+\>"
	" autocmd VimEnter *.ml syn match ocamlFunc "\(\w\+\s\+\)\@<!\w\+\(\(\s\+\w\+\)\{1,\}\)\@="
	autocmd VimEnter *.ml syn match ocamlIf "\<if\>"
	autocmd VimEnter *.ml syn match ocamlIf "\<then\>"
	autocmd VimEnter *.ml syn match ocamlIf "\<else\>"
	autocmd VimEnter *.ml syn match ocamlArrow "->"
	autocmd VimEnter *.ml syn match ocamlArrow "|"
	autocmd VimEnter *.ml syn match ocamlSymbol "@"
	autocmd VimEnter *.ml syn match ocamlSymbol ":\{-2\}"
augroup END

