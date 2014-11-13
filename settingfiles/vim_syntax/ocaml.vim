hi ocamlKeyword cterm=bold ctermfg=226
hi ocamlKeyChar cterm=bold ctermfg=47
hi ocamlFunc cterm=bold ctermfg=81
hi ocamlIf cterm=bold ctermfg=48
hi ocamlDoubleSemicolon cterm=bold ctermfg=48
hi link ocamlArrow ocamlKeyword
hi link ocamlSymbol ocamlIf

syn match ocamlKeyword /\(\s\+\)\@<=to\(\s\+\)\@=/
syn match ocamlDoubleSemicolon /\<;;\>/
syn match ocamlFunc /\(\<let\s\+\(rec\s\+\)\{0,1\}\)\@<=\w\+\>/
syn match ocamlFunc /\(\<and\s\+\)\@<=\w\+\>/
syn match ocamlFunc /\<print_\h\+\>/
" syn match ocamlFunc "\(\w\+\s\+\)\@<!\w\+\(\(\s\+\w\+\)\{1,\}\)\@="
syn keyword ocamlIf if
syn keyword ocamlIf then
syn keyword ocamlIf else
syn keyword ocamlArrow ->
syn keyword ocamlArrow |
syn keyword ocamlSymbol @
syn match ocamlSymbol /:\{-2\}/

