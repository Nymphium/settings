hi luaFunction cterm=bold ctermfg=214
hi luaLength cterm=bold ctermfg=62
hi link luaBracket String
hi luaCond cterm=bold ctermfg=48
hi link luaElse luaCond
hi luaChar cterm=bold

syn match luaChar /[=%<>/+\*,]/
syn match luaChar /\([\w\s]\)\@<=\.\.\([\w\s]\)\@=/
syn match luaChar /-\(-\)\@!/
" syn match luaBracket "[)}]"
syn match luaLength /#\(\h\)\+\>/
syn match luaTable /\w\+\([\.:]\)\@=/
syn match luaTable /\w\+\s*\(=\_s*\)\@=/
syn match luaFunc /\(\<function\>\)\@<=\s\+\<\w\+\s*\>\@=/
syn match luaFunc /\<\w\>\(\s*(.*)\)\@=/
syn match luaFunc /\<\([^io\W][^fr\W]\)\>\(\s*(.*)\)\@=/
syn match luaFunc /\<\([^na\W][^on\W][^td\W]\)\>\(\s*(.*)\)\@=/
syn match luaFunc /\<\w\{4,6\}\>\(\s*(.*)\)\@=/
syn match luaFunc /\<\w\{7,\}\>\(\s*(.*)\)\@=/
syn match luaFunc /\<\w\+\>\(\s*=\s*function\)\@=/
syn region luaString start="\[\[" end="\]\]" contains=ALL
