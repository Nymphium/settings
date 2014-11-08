colorscheme rdark
hi CursorLine cterm=none ctermbg=237
hi CursorColumn cterm=none ctermbg=237
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

"" for Lua
hi luaFunction cterm=bold ctermfg=214
hi luaLength cterm=bold ctermfg=62
hi link luaBracket String
hi luaCond cterm=bold ctermfg=48
hi link luaElse luaCond
hi luaChar cterm=bold

augroup LuaSntax
	autocmd!
	autocmd VimEnter *.lua syn match luaChar "[=%<>/+\*,]"
	autocmd VimEnter *.lua syn match luaChar "[\w\s]\.\.[\w\s]"
	autocmd VimEnter *.lua syn match luaChar "-\(-\)\@!"
	autocmd VimEnter *.lua syn match luaBracket "[(){}\[\]]"
	autocmd VimEnter *.lua syn match luaLength "#\(\h\)\+\>"
	autocmd VimEnter *.lua syn match luaTable "\w\+\([\.:]\)\@="
	autocmd VimEnter *.lua syn match luaTable "\w\+\s*\(=[ \_s\t]*\)\@="
	autocmd VimEnter *.lua syn match luaFunc "\(\<function\>\)\@<=\s\+\<\w\+\s*\>\@="
	" autocmd VimEnter *.lua syn match luaFunc "\(\(if\)\|\(or\)\|\(and\)\|\(function\)\)\@<!\w*\(\<(\_.*)\)\@="
	autocmd VimEnter *.lua syn match luaFunc "\<\w\+\>\(\s*=\s*function\)\@="
augroup END

"" for OCaml
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
