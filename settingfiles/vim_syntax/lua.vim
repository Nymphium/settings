" Vim syntax file
" Language: Lua
" Maintainer: Nymphium

hi luaFunction cterm=bold ctermfg=214
hi luaLength cterm=bold ctermfg=62
hi link luaBracket String
hi luaCond cterm=bold ctermfg=48
hi link luaElse luaCond
hi luaChar cterm=bold

syn match luaChar /[=%<>/+\*,]/
syn match luaChar /\([\w\s]\)\@<=\.\.\([\w\s]\)\@=/
syn match luaChar /-\(-\)\@!/
syn match luaLength /#\w\+\>/
syn match luaTable /\w\+\([\.:]\)\@=/
syn match luaTable /\w\+\s*\(=\_s*\)\@=/
syn match luaFunc display /\<\w\+\>\(\s*(.*)\)\@=/ contains=ALLBUT,luaCond,luaKeyword,luaFunction,luaOperator,luaIn,luaStatement
syn match luaFunc display /\<\w\+\>\(\s*=\s*function\)\@=/
syn match luaFunc display /\<\w\+\>\(\s*\w\+\s*,\?\)\@=/
syn region luaString start="\[\[" end="\]\]" contains=ALL

autocmd VimEnter,FileType * if &filetype == "lua" | syn match luaBracket /[(){}\[\]]/ | endif

