hi link cChar cType
hi link cFunc cInclude
hi link cSurround String

augroup CSyntax
	autocmd!
	autocmd VimEnter *.c syn match cChar "[!=%<>+,\(\->\)\-]"
	autocmd VimEnter *.c syn match cChar "/\(\*\|/\)\@!"
	autocmd VimEnter *.c syn match cChar "\(/\)\@<!\*"
	autocmd VimEnter *.c syn match cFunc "\(\<\(\(int\)\|\(void\)\|\(char\)\|\(double\)\|\(float\)\)\s\+\)\@<=\w\+\(\s*(.*)\)\@="
	autocmd VimEnter *.c syn match cSurround "[(){}\[\]]"
augroup END
