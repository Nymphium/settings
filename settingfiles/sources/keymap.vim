vnoremap <silent> <ESC> <ESC><ESC>:nohlsearch<CR>
vnoremap v $h
vnoremap L <Nop>
vnoremap H <Nop>
vnoremap W b
vnoremap E <Nop>
vnoremap E e
vnoremap <ESC>L $
vnoremap <ESC>H ^
vnoremap <ESC>j <C-d>
vnoremap <ESC>k <C-u>
vnoremap <TAB> >
vnoremap <S-Tab> <
vnoremap <silent> n "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
vnoremap <S-y> "+y

nnoremap <silent> <ESC> <ESC><ESC>:nohlsearch<CR>
nnoremap <ESC>a <ESC>:saveas 
" nnoremap <ESC>s <Nop>
nnoremap <ESC>s <ESC>:w!<CR>
nnoremap <ESC>s<ESC>s <ESC>:wq!<CR>
" nnoremap <ESC>w <Nop>
nnoremap <ESC>w<ESC>w <ESC>:q!<CR>
nnoremap <BS> X
nnoremap <ESC>1 <C-x>
nnoremap <ESC>2 <C-a>
nnoremap j gj
nnoremap k gk
nnoremap E <Nop>
nnoremap E w
nnoremap W <Nop>
nnoremap W b
nnoremap r <C-r>
nnoremap <ESC>j <C-d>
nnoremap <ESC>k <C-u>
nnoremap <silent> <F3> :setlocal relativenumber!<CR>
nnoremap I <Nop>
nnoremap <silent> II :let l=line(".")<CR>:let c=col(".")<CR><ESC>gg=G:call cursor(l,c)<CR>
nnoremap ww <ESC>:vne<Space>
nnoremap wv <ESC>:new<Space>
nnoremap w<TAB> <C-w>w
nnoremap wl <ESC><C-w><<C-w><<C-w><<C-w><<C-w><
nnoremap wh <ESC><C-w>><C-w>><C-w>><C-w>><C-w>>
nnoremap wj <ESC><C-w>+<C-w>+<C-w>+<C-w>+<C-w>+
nnoremap wk <ESC><C-w>-<C-w>-<C-w>-<C-w>-<C-w>-
nnoremap <return> <ESC>i<return><ESC>
nnoremap <TAB> >>
nnoremap <S-Tab> <<
nnoremap <ESC>o <Nop>
nnoremap <ESC>o o<ESC>
nnoremap wo :new<Space><cfile><CR>
nnoremap <S-k> k<S-j>
nnoremap <silent> <F11> <ESC>:Q<CR>
nnoremap V <C-v>

inoremap <silent> <ESC> <ESC><ESC>:nohlsearch<CR>
inoremap <ESC>v <Nop>
inoremap <ESC>v <ESC>"*pa
inoremap <ESC>1 <Nop>
inoremap <ESC>2 <Nop>
inoremap <ESC>1 <ESC><C-x>i
inoremap <ESC>2 <ESC><C-a>i
inoremap <ESC>p <ESC>pi
inoremap <ESC>d <ESC>ddi
inoremap <ESC>w <S-Left>
inoremap <ESC>e <S-Right>
inoremap <C-q> <ESC>:q!<CR>
inoremap <F3> <ESC><ESC>:setlocal relativenumber!<CR>a
inoremap " <Nop>
inoremap " ""<Left>
inoremap ` <Nop>
inoremap ` ``<Left>
inoremap ( <Nop>
inoremap ( ()<Left>
inoremap { <Nop>
inoremap { {}<Left>
inoremap [ <Nop>
inoremap [ []<Left>
