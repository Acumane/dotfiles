set nocompatible
set shortmess=IA
set number relativenumber
set clipboard=unnamedplus
set fillchars=eob:\ 
set smartindent
set autoindent
set shiftwidth=4
set expandtab
set smartcase
set laststatus=0
set mps+=<:>

if exists(':terminal')
  " issues #3681, #23645; my day is ruined
  au TermOpen * setlocal nonumber norelativenumber
  au TermOpen * setlocal modifiable
  au TermOpen * startinsert
endif

lua require("init")

" Improved arrow navigation and commands
nmap i gk
vmap i gk
map j <Left>
map k gj

" (i)nsert -> (h)ere OR (i)nner
noremap h i
nnoremap H a
" remove annoying dir motion, use i still (i)nner
onoremap <Down> <Nop>
" center screen on insert
au InsertEnter * norm! zz
" enter normal mode in the same place!
au InsertLeave * exec "normal! `^"
vnoremap H A
vnoremap hh <Esc>i
vnoremap hi <Esc>i
map s v

let surround =
\ ['`', '"', ')', ']', '{', '}', '>', '*', '_', '$']

for ch in surround
  exec "nnoremap <nowait>" ch "<Cmd>norm vhwS".ch."el<CR>"
  " exec "nnoremap <nowait>" ch ":let w=winsaveview()<CR>:norm vhwS".ch."<CR>:call winrestview(w)<CR>l"
  exec "vnoremap <nowait>" ch ":<C-u>exec 'norm gvS".ch."l'<CR>"
  " delete given pair (d*)
  exec "nmap d".ch "ds".ch
endfor
" TODO: mark conflict
nnoremap ' <Cmd>norm vhwS'el<CR>
vnoremap ' :<C-u>exec "norm gvS'l"<CR>
nmap d' ds'

" cycle case/CASE
vnoremap  ~ ~gv
nnoremap  ~ ~h

map tk tn
"   t* (to case) - WIP
noremap tt :lua require('textcase')
\ .current_word('to_phrase_case')<CR>

nnoremap = <C-a> 
nnoremap + <C-a> 
" nnoremap a <C-a> 
nnoremap - <C-x> 
" nnoremap s <C-x> 

map <space> h<space><esc>
map <backspace> h<backspace><esc>

" better line appending!
nnoremap a<space>i J
nnoremap ai gJ

" consistent bracket pair nav
nnoremap o %
nnoremap O %

" A = aa (NOT aL), where a is r,c,x,d
" renaming change -> replace:
noremap  r  "_c
nnoremap R  "_cc
nnoremap rr "_cc
noremap  c  y
nnoremap C  yy
nnoremap cc yy
" r(eplace) l(etter):
nnoremap rl r
nmap rj <Nop> 
" old del -> cut:
noremap  x  d
nnoremap X  dd
nnoremap xx dd
" restoring transpose:
nnoremap xp xp
vnoremap p "_dP

" adding true delete:
noremap  d  "_d
nnoremap D  "_dd
nnoremap dd "_dd

" expected Ctrl functions:
nnoremap <C-a> gg^vG$h
vnoremap <C-a> gg^oG$h
inoremap <C-a> <Esc>gg^vG$h
tnoremap <Esc> <C-\><C-n>

if !exists('g:vscode')
  " <[S|C]-Del> (kitty)
  nmap <S-Del> dvb
  colorscheme kanagawa
  imap <S-Del> <C-w>
  cmap <S-Del> <C-w>
  nnoremap q :q<CR>
  set guicursor+=i-c:ver1
  set guicursor+=n-i-c:blinkon500
  set cmdheight=0
else
  set cmdheight=1
endif

vmap <C-c> y
vmap <C-x> x
map  <C-p> p

"         <C-r>
noremap   <C-u> u
noremap u <Nop>

" New text objects
let new_obj = [ '*', '_', '$']
for ch in new_obj
  exec 'omap i'.ch ':<C-u>norm! T'.ch.'vt'.ch.'<CR>'
  exec 'vmap h'.ch 'T'.ch.'ot'.ch
  exec 'omap a'.ch ':<C-u>norm! F'.ch.'vf'.ch.'<CR>'
  exec 'vmap a'.ch 'F'.ch.'of'.ch
endfor

" mnemonic text objects
let pairs = {
\ 'p': ')', 'b': ']', 'B': '}', 'q': '"', 't': '>', 'u': '_', 'e': '*', 'm': '$'
\ }
for [l, r] in items(pairs)
  exec 'omap i'.l 'i'.r
  exec 'omap h'.l 'i'.r
  exec 'vnoremap h'.l 'i'.r
  exec 'omap a'.l 'a'.r
  exec 'vmap a'.l 'a'.r
  exec 'nmap rs'.l 'css'.r
  exec 'nmap d'.l 'ds'.r
endfor
onoremap hP ip
vnoremap hP ip
onoremap aP ap
vnoremap aP ap

" pair replace
let obj = ['t', 'p', 'b', 'B', 'u', 'e', 'm', 'q', 's', 
\ '>', ')', ']', '}', '_', '*', '$', '"', "'", '`']
for a in obj
  for b in obj
    exec 'nmap r'.a.b 'cs'.a.b
  endfor
endfor

function! Word(m, ...)
  let v = get(a:, 1, "")
  exec "norm! ".v.a:m
  while strpart(getline('.'), col('.') - 1, 1) !~ '\w'
    if getline('.') == ''
      return
    endif
    exec "norm! ".v.a:m
  endwhile
endfunction

"       w
noremap W     b
"       e
noremap E     ge

" nnoremap t    H
" nnoremap b    L
"        M
noremap  T    gg
map      B    GL

noremap  I    {
noremap  K    }
noremap  J    g0
noremap  L    $
vnoremap L    g_

" (n)ext occurence
noremap n f
noremap N F
noremap , ;
noremap < ,

" (S-)enter doubles as newline & search
nnoremap <expr> <enter> @/ == "" ? 'o' : 'n'
nnoremap <expr> <S-enter> @/ == "" ? 'O' : 'N'

" (m)ulticursor
if exists('g:vscode')
  nmap <expr> m @/ == "" ? '\m' : 'gn\m<Cmd>norm! n<CR>'
  vmap <nowait><expr> m @/ == "" ? '\m' : '\m<Cmd>norm! n<CR>'
  nmap <expr> M @/ == "" ? '' : 'gN\m<Cmd>norm! N<CR>'
  vmap <nowait><expr> M @/ == "" ? '' : '\m<Cmd>norm! NN<CR>'
endif

" (f)ind
nnoremap <silent> f :let @/=expand('<cword>')<CR>:set hls<CR>:call feedkeys('/'.@/)<CR>
vnoremap <silent> f y:let @/=@" <bar>:set hls<CR>gn

" clear search pattern register (@/):
nnoremap <Esc> <Cmd>nohl<CR><Cmd>let @/ = ""<CR>
augroup ClearSearch
  au! BufReadPost * let @/ = ""
augroup END


" <#>G -> <#>g
nnoremap <nowait><expr> g v:count ? 'G' : 'g'

" ;<x> sets mark or goes to mark
function! Mark()
    let char = nr2char(getchar())
    let pos = getpos("'" . char)
    execute "normal! " . (pos[1] == 0 && pos[2] == 0 ? "m" : "`") . char
endfunction
nnoremap <silent> ; :call Mark()<CR>

" delete mark(s)
nnoremap <silent> d; :exec "delmarks ".nr2char(getchar())<CR>
nnoremap <silent> da; :delmarks!<CR>

" Tab in normal mode
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" better block mode
vnoremap b <C-v>
