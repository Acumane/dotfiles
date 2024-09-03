set nocompatible
set shortmess=I
set number relativenumber
set clipboard=unnamedplus
set fillchars=eob:\ 
set smartindent
set autoindent
set shiftwidth=4
set expandtab
set smartcase
set cmdheight=0
set laststatus=0

if exists(':terminal')
  " issues #3681, #23645; my day is ruined
  au!
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
\ ['`', '"', '(', ')', '[', ']', '{', '}', '<', '>', '*', '_', '$']

for ch in surround
  " autowrapping word in normal mode
  exec "nnoremap <silent><nowait>" ch ":<C-u>exec 'norm vhwS".ch."'<CR>"
  " autowrapping selection in visual mode
  exec "vnoremap <silent><nowait>" ch ":<C-u>exec 'norm gvS".ch."'<CR>"
  " delete given pair (d*)
  exec "nmap d".ch "ds".ch
endfor
" TODO: mark conflict
nnoremap <silent> '' :<C-u>exec "norm vhwS'"<CR>
vnoremap <silent> '' :<C-u>exec "norm gvS'"<CR>
nmap d' ds'

" cycle case/CASE
vnoremap  ~ ~gv
nnoremap  ~ ~h
map tk tn
"   t* (to case) - WIP
noremap tt :lua require('textcase')
\ .current_word('to_phrase_case')<CR>
" *use Ctrl+u/r

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

" Power delete (kitty)
nmap <S-Del> dvb
if !exists('g:vscode')
  colorscheme kanagawa
  imap <S-Del> <C-w>
endif

vmap <C-c> y
vmap <C-x> x
map  <C-p> p
map  <C-u> u
"    <C-r>

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

" better word nav
" for [l, r] in items({'w': 'w', 'e': 'e', 'W': 'b', 'E': 'ge'})
  " exec "nnoremap <silent>" l ":call Word('".r."')<CR>"
  " exec "vnoremap <silent>" l ":call Word('".r."', 'gv')<CR>"
" endfor
"       w
noremap W     b
"       e
noremap E     ge

nnoremap t    H
nnoremap b    L
"        M
noremap  T    gg
map      B    GL

" \s, wrap compatible
noremap  I    {
noremap  K    }
noremap  J    g0
noremap  L    g_

" commands (WIP)
noremap / :
nnoremap f /
vnoremap f <Esc>*
noremap <enter> n
noremap <S-enter> N
noremap <silent> <Esc><Esc> :<C-u>nohl<CR>

" 'Go', ex. 5g
nnoremap '    m
nnoremap g'   `
nnoremap <nowait><expr> g v:count ? 'G' : 'g'
" TODO: m -> multi

" better newline!
noremap n o
noremap N O

" Tab in normal mode
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" better block mode
vnoremap b <C-v>