hi link cChar cType
hi link cFunc cInclude
hi link cSurround String

syn match cChar "[!=%<>+,\(\->\)\-]"
syn match cChar "/\(\*\|/\)\@!"
syn match cChar "\(/\)\@<!\*"
syn match cFunc "\(\<\(\(int\)\|\(void\)\|\(char\)\|\(double\)\|\(float\)\)\s\+\)\@<=\w\+\(\s*(.*)\)\@="
<<<<<<< HEAD
syn match cSurround display e"[(){}\[\]]"
=======
syn match cSurround display "[(){}\[\]]"
>>>>>>> ebf5bccaaa289ccaef588b619f81331d9ff6bbe3

