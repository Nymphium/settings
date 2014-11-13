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
" syn region luaBracket matchgroup=luaBracket start=/\[/ end=/\]/ contains=ALL
" syn region luaBracket matchgroup=luaBracket start=/(/ end=/)/ contains=ALL
" syn region luaBracket matchgroup=luaBracket start=/{/ end=/}/ contains=ALL
syn region luaBracket transparent matchgroup=luaBracket start="(" end=")" contains=ALL
syn match luaLength /#\(\h\)\+\>/
syn match luaTable /\w\+\([\.:]\)\@=/
syn match luaTable /\w\+\s*\(=\_s*\)\@=/
syn match luaFunc display /\<\w\+\>\(\s*(.*)\)\@=/ contains=ALLBUT,luaCond,luaKeyword,luaFunction,luaOperator,luaIn,luaStatement
syn region luaString start="\[\[" end="\]\]" contains=ALL

