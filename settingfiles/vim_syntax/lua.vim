hi luaFunction cterm=bold ctermfg=214
hi luaLength cterm=bold ctermfg=62
hi link luaBracket String
hi luaCond cterm=bold ctermfg=48
hi link luaElse luaCond
hi luaChar cterm=bold

syn match luaChar "[=%<>/+\*,]"
syn match luaChar "\([\w\s]\)\@<=\.\.\([\w\s]\)\@="
syn match luaChar "-\(-\)\@!"
syn match luaBracket "[)}\]]"
syn match luaLength "#\(\h\)\+\>"
syn match luaTable "\w\+\([\.:]\)\@="
syn match luaTable "\w\+\s*\(=[ \_s\t]*\)\@="
syn match luaFunc "\(\<function\>\)\@<=\s\+\<\w\+\s*\>\@="
	" autocmd VimEnter *.lua syn match luaFunc "\(\(if\)\|\(or\)\|\(and\)\|\(function\)\)\@<!\w*\((\_.*)\)\@="
syn match luaFunc "\<\w\+\>\(\s*=\s*function\)\@="


