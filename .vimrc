"Requires viem.ahk

"Improved arrow navigation and commands
map i <Up>
map j <Left>
map k <Down>

"(i)nsert -> (h)ere OR (i)nner
noremap h i
nnoremap H a
" remove annoying up/down motions, use i as (i)nner motion
onoremap <Up> i
onoremap <Down> <Nop>
" for visual mode(s):
noremap H A

"Brute-force fix until I find the issue ig :/
onoremap iq i"
onoremap ip i)
onoremap ib i]
onoremap iB i}
onoremap it i>
onoremap aq a"
onoremap ap a)
onoremap ab a]
onoremap aB a}
onoremap at a>

vnoremap aq a"
vnoremap ap a)
vnoremap ab a]
vnoremap aB a}
vnoremap at a>
vnoremap hq i"
vnoremap hp i)
vnoremap hb i]
vnoremap hB i}
vnoremap ht i>

"Better autowrapping:
nnoremap ` viwS`
nnoremap ' viwS'
nnoremap " viwS"
nnoremap ( viwS)
nnoremap ) viwS)
nnoremap [ viwS]
nnoremap ] viwS]
nnoremap { viwS}
nnoremap } viwS}
nnoremap < viwS>
nnoremap > viwS>
nnoremap * viwS*
nnoremap _ viwS_

vnoremap ` S`
vnoremap ' S'
vnoremap " S"
vnoremap ( S)
vnoremap ) S)
vnoremap [ S]
vnoremap ] S]
vnoremap { S}
vnoremap } S}
vnoremap < S>
vnoremap > S>
vnoremap * S*
vnoremap _ S_

nmap d` ds`
nmap d' ds'
nmap d" ds"
nmap dq ds"
nmap d( ds)
nmap d) ds)
nmap dp ds)
nmap d[ ds]
nmap d] ds]
nmap db ds]
nmap d{ ds}
nmap d} ds}
nmap dB ds}
nmap d< ds>
nmap d> ds>
nmap dt ds>
nmap d* ds*
nmap d_ ds_


map ~ <Nop>
"~: cycles Case -> case -> CASE
nnoremap u gu
nnoremap U gU
" *must now use Ctrl+u/r

"better line appending!
nnoremap a<space>i J
nnoremap ai gJ

"consistent bracket pair nav
nnoremap o %
nnoremap O %

" Z = zz (NOT zL), where z is r,c,x,d
" renaming change->replace:
noremap r "_c
nnoremap R "_cc
nnoremap rr "_cc
noremap c y
nnoremap C yy
nnoremap cc yy
"special replace character->rc:
nnoremap rl r
"old del->cut, keep transpose:
noremap x d
nnoremap X dd
nnoremap xx dd
"restoring transpose:
nnoremap xp xp

"adding true delete:
noremap d "_d
nnoremap D "_dd
nnoremap dd "_dd

"expected Ctrl+A function:
noremap <C-a> ggvG$
inoremap <C-a> <Esc>ggvG$

"Unmapping awkward power navigation keys
map $ <Nop>
map ^ <Nop>

map <enter> <Nop>
" <C-a> replaces
omap ie <Nop>
omap ae <Nop>
omap he <Nop>

"better word navigation
"       w
noremap W     b
"       e
noremap E     ge

noremap t     H
" TEMP: n- to save block mode
nnoremap b    L
noremap T     gg
noremap B     G
" e.g.  5gt
noremap gt    gg

noremap I     {
noremap K     }
noremap J      ^
nnoremap L     $

vnoremap L     $h

"better newline!
noremap n o
noremap N O

"Can now use tabs in NORMAL mode instead of >> and <<
nmap >> <Nop>
nmap << <Nop>
vmap >> <Nop>
vmap << <Nop>
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

"better block mode
vnoremap b <C-v>
"       gh     gesture: hover
"multi-cursor mode
noremap m gb
"       n      next/skip
"       M      undo cursor