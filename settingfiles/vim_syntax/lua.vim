hi luaFunction cterm=bold ctermfg=214
hi luaLength cterm=bold ctermfg=62
hi link luaBracket String
hi luaCond cterm=bold ctermfg=48
hi link luaElse luaCond
hi luaChar cterm=bold

augroup LuaSntax
	autocmd!
	autocmd VimEnter *.lua syn match luaChar "[=%<>/+\*,]"
	autocmd VimEnter *.lua syn match luaChar "\([\w\s]\)\@<=\.\.\([\w\s]\)\@="
	autocmd VimEnter *.lua syn match luaChar "-\(-\)\@!"
	autocmd VimEnter *.lua syn match luaBracket "[(){}\[\]]"
	autocmd VimEnter *.lua syn match luaLength "#\(\h\)\+\>"
	autocmd VimEnter *.lua syn match luaTable "\w\+\([\.:]\)\@="
	autocmd VimEnter *.lua syn match luaTable "\w\+\s*\(=[ \_s\t]*\)\@="
	autocmd VimEnter *.lua syn match luaFunc "\(\<function\>\)\@<=\s\+\<\w\+\s*\>\@="
	" autocmd VimEnter *.lua syn match luaFunc "\(\(if\)\|\(or\)\|\(and\)\|\(function\)\)\@<!\w*\((\_.*)\)\@="
	autocmd VimEnter *.lua syn match luaFunc "\<\w\+\>\(\s*=\s*function\)\@="
augroup END


