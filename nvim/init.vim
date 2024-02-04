set nocompatible
set shortmess=I
set number relativenumber
set clipboard=unnamedplus
set fillchars=eob:\
set smartindent
set autoindent
set shiftwidth=4
set expandtab

lua require("init")

" Improved arrow navigation and commands
map i <Up>
map j <Left>
map k <Down>

" (i)nsert -> (h)ere OR (i)nner
noremap h i
nnoremap H a
" remove annoying up/down motions, use i as (i)nner motion
onoremap <Up> i
onoremap <Down> <Nop>
" center screen on insert
autocmd InsertEnter * norm! zz
" enter normal mode in the same place!
autocmd InsertLeave * execute "normal! `^"
vnoremap H A

let surround =
\ ['`', "'", '"', '(', ')', '[', ']', '{', '}', '<', '>', '*', '_', '$']

for ch in surround
  " autowrapping word in normal mode
  execute 'nnoremap <silent><nowait> '.ch.' :<C-u>exec "norm vhwS'.ch.'"<CR>'
  " autowrapping selection in visual mode
  execute 'vnoremap <silent><nowait> '.ch.' :<C-u>exec "norm gvS'.ch.'"<CR>'
  " delete given pair (d*)
  execute 'nmap d'.ch.' ds'.ch
endfor
nnoremap <silent> " :<C-u>exec 'norm vhwS"'<CR>
vnoremap <silent> " :<C-u>exec 'norm gvS"'<CR>
nmap d" ds"

" cycle case/CASE
noremap  ~ ~gv
nnoremap u gu
nnoremap U gU
" *use Ctrl+u/r

map <space> h<space><esc>
" map <enter> h<enter><esc>
map <backspace> h<backspace><esc>

" better line appending!
nnoremap a<space>i J
nnoremap ai gJ

" consistent bracket pair nav
nnoremap o %
nnoremap O %

" A = aa (NOT aL), where a is r,c,x,d
" renaming change->replace:
noremap  r  "_c
nnoremap R  "_cc
nnoremap rr "_cc
noremap  c  y
nnoremap C  yy
nnoremap cc yy
" r(eplace) l(etter):
nnoremap rl r
nmap rj <Nop>
" old del->cut:
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

" expected Ctrl+A function:
noremap <C-a> gg^vG$h

inoremap <C-a> <Esc>gg^vG$h

" Power delete (kitty)
nmap <S-Del> dvb
imap <S-Del> <C-w>

vnoremap <C-c> y
vnoremap <C-x> d
noremap  <C-p> p
noremap  <C-u> u
"        <C-r> r

" Unmapping awkward power nav keys
" map $ <Nop>
map ^ <Nop>

" New text objects
let text_obj = [ '*', '_', '$']
for ch in text_obj
  execute 'omap i'.ch.' :<C-u>norm! T'.ch.'vt'.ch.'<CR>'
  execute 'vmap h'.ch.' T'.ch.'ot'.ch
  execute 'omap a'.ch.' :<C-u>norm! F'.ch.'vf'.ch.'<CR>'
  execute 'vmap a'.ch.' F'.ch.'of'.ch
endfor

" mnemonic text objects
let pairs = {
\ 'p': ')', 'b': ']', 'B': '}', 'q': '"', 't': '>', 'u': '_', 'e': '*', 'm': '$'
\ }
for [l, r] in items(pairs)
  execute 'omap i'.l.' i'.r
  execute 'vmap h'.l.' h'.r
  execute 'omap a'.l.' a'.r
  execute 'vmap a'.l.' a'.r
  execute 'nmap d'.l.' ds'.r
  execute 'nmap rs'.l.' css'.r
endfor
nmap rs css
" nmap ds dss

" mnemonic pair replace
let re_pairs = {
\ 'pq': ')"', 'pb': ')]', 'qp': ')"', 'qb': ']"', 'bq': ']"', 'bp': '])'
\ }
for [l, r] in items(re_pairs)
  execute 'nmap r'.l.' cs'.r
endfor

function! Word(m, ...)
  let v = get(a:, 1, "")
  exec "norm! ".v.a:m
  while strpart(getline('.'), col('.') - 1, 1) !~ '\w'
      if col('.') >= col('$') - 1 || getline('.') == ''
        return
      endif
      exec "norm! ".v.a:m
  endwhile
endfunction

" better word nav
for [l, r] in items({'w': 'w', 'e': 'e', 'W': 'b', 'E': 'ge'})
  exec "nnoremap <silent>" l ":call Word('".r."')<CR>"
  exec "vnoremap <silent>" l ":call Word('".r."', 'gv')<CR>"
endfor

noremap  t    H
nnoremap b    L
noremap  T    gg
map      B    GL

" 'Go to', ex. 5gt
noremap gt    gg

noremap  I     {
noremap  I     {
noremap  K     }
noremap  J     ^
nnoremap L     $
vnoremap L     $h
" better newline!
noremap n o
noremap N O

" Tab in normal mode
map >> <Nop>
map << <Nop>
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" better block mode
vnoremap b <C-v>
