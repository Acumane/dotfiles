"Requires viem.ahk

"Improved arrow navigation and commands
map i <Up>
map j <Left>
map k <Down>
vnoremap h i
vnoremap H A
noremap h i
noremap H a

" better line appending!
nnoremap a<space> J
nnoremap aa gJ


" consistent bracket pair nav
nnoremap o %
nnoremap O %

" renaming change->replace, changing cut, and adding true delete
noremap r c
noremap c y
nnoremap rc r
noremap x d
noremap X D
nnoremap xx dd
noremap d "_d
nnoremap D "_D
nnoremap dd "_dd

noremap <C-a> ggvG$
inoremap <C-a> <Esc>ggvG$



"Consistent X, D, C*, R* keymaps
nnoremap R C
nnoremap C y$

"Unmapping awkward power navigation keys
map $ <Nop>
map ^ <Nop>
map { <Nop>
map } <Nop>

"better word navigation
"       w
noremap <C-w>   W
noremap W       b
noremap <C-W>   B
"       e
noremap <C-e>   E
noremap E       ge
noremap <C-E>   gE

noremap t     H
" noremap m     M
noremap b     L
noremap T     gg
noremap B     G
noremap gt    gg

noremap I     {
noremap K     }
noremap J     ^
noremap L     $

"better newline!
noremap n o
noremap N O

"Can now use tabs in NORMAL mode in stead of >> and <<
nmap >> <Nop>
nmap << <Nop>
vmap >> <Nop>
vmap << <Nop>
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

"Multi-cursor mode
noremap M gb
"gh -> hover

" TODO:
" revisit word nav