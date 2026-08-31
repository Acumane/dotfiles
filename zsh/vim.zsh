# Vim keymap for ZLE

bindkey -v
KEYTIMEOUT=5

autoload -Uz surround select-bracketed select-quoted
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# Select-bracketed/-quoted are called as nested widgets, so must be registered
for w in select-bracketed select-quoted \
         up-line-or-beginning-search down-line-or-beginning-search; do zle -N $w; done
zle -N delete-surround surround
zle -N add-surround    surround
zle -N change-surround surround

typeset -gA VIM_PAIRS=( p ')' b ']' B '}' t '>' q '"' )  # closing char: no padding

# viins-only bindings die the moment you press Esc
vim-bind() { local m; for m in viins vicmd visual; do bindkey -M $m "$1" "$2"; done }

# —— Esc ————————————————————————————————————————————————
# Dismiss autosuggestion, drop cursor to the right
vim-normal-mode() {
  (( $+functions[_zsh_autosuggest_clear] )) && _zsh_autosuggest_clear
  local -i pos=$CURSOR
  zle vi-cmd-mode
  (( CURSOR = pos < $#BUFFER ? pos : $#BUFFER - 1 ))
  (( CURSOR < 0 )) && CURSOR=0
}
zle -N vim-normal-mode
bindkey -M viins '^[' vim-normal-mode

# —— Motions ————————————————————————————————————————————
# viopp is excluded so op-pending `i` stays the stock inner-object prefix
bindkey -M vicmd  'i' up-line-or-beginning-search
bindkey -M vicmd  'k' down-line-or-beginning-search
bindkey -M visual 'i' up-line-or-history
bindkey -M visual 'k' down-line-or-history
bindkey -M vicmd  'h' vi-insert
bindkey -M vicmd  'H' vi-add-next
for m in vicmd visual; do bindkey -M $m 'j' vi-backward-char; done

vim-buffer-start() { if (( CURSOR )); then CURSOR=0; else zle up-line-or-history; fi }
# *-of-buffer-or-history parks past a trailing newline that vicmd clamps back
# off, so K flips between two spots forever; and somewhere vicmd will hold
vim-buffer-end() {
  setopt localoptions extendedglob
  local -i t=$(( ${#${BUFFER%%$'\n'#}} - 1 ))
  (( t < 0 )) && t=0
  if (( CURSOR < t )); then CURSOR=$t; else zle down-line-or-history; fi
}

vim-wordish() { [[ $1 == [[:alnum:]] || ( -n $WORDCHARS && $WORDCHARS == *"$1"* ) ]] }
# ZLE has no `ge`: vi-forward-word-end hangs on one-character words; scan for the end instead
vim-backward-word-end() {
  local -i n=${NUMERIC:-1} c a b
  local cur nxt
  while (( n-- > 0 )); do
    for (( c = CURSOR - 1; c >= 0; c-- )); do
      cur=$BUFFER[c+1] nxt=$BUFFER[c+2]
      [[ $cur == [[:space:]] ]] && continue
      [[ -z $nxt || $nxt == [[:space:]] ]] && break
      vim-wordish $cur; a=$?
      vim-wordish $nxt; b=$?
      (( a != b )) && break
    done
    (( c < 0 )) && c=0
    CURSOR=$c
  done
}
zle -N vim-buffer-start
zle -N vim-buffer-end
zle -N vim-backward-word-end

# I/K have no paragraphs to jump between here, so they double up with T/B
for m in vicmd visual viopp; do
  bindkey -M $m 'L' vi-end-of-line
  bindkey -M $m 'J' vi-beginning-of-line
  bindkey -M $m 'W' vi-backward-word
  bindkey -M $m 'E' vim-backward-word-end
  bindkey -M $m 'T' vim-buffer-start
  bindkey -M $m 'I' vim-buffer-start
  bindkey -M $m 'B' vim-buffer-end
  bindkey -M $m 'K' vim-buffer-end
done

# —— Verbs ——————————————————————————————————————————————
if (( $+commands[wl-copy] )); then
  vim-copy()  { wl-copy --type text/plain 2>/dev/null }
  vim-paste() { wl-paste --no-newline 2>/dev/null }
elif (( $+commands[xclip] )); then
  vim-copy()  { xclip -selection clipboard 2>/dev/null }
  vim-paste() { xclip -selection clipboard -o 2>/dev/null }
else
  vim-copy()  { cat >/dev/null }
  vim-paste() { }
fi
vim-pull() { local c=$(vim-paste); [[ -n $c ]] && CUTBUFFER=$c }

# c/x mirror nvim's clipboard=unnamedplus by wrapping the builtins in place
vim-clip-out() { zle ".$WIDGET"; print -rn -- "$CUTBUFFER" | vim-copy }
vim-clip-in()  { vim-pull; zle ".$WIDGET" }
zle -N vi-yank       vim-clip-out
zle -N vi-delete     vim-clip-out
zle -N vi-put-after  vim-clip-in
zle -N vi-put-before vim-clip-in

# r/d discard instead of filling the cut buffer
typeset -g VIM_OP=
vim-blackhole() { local c=$CUTBUFFER; zle ".$1"; CUTBUFFER=$c }
vim-delete() { VIM_OP=d; vim-blackhole vi-delete; VIM_OP= }
vim-change() { VIM_OP=r; vim-blackhole vi-change; VIM_OP= }
# nvim's "_dP: replace the selection, keep the register
vim-visual-put() {
  vim-pull
  local reg=$CUTBUFFER
  zle .vi-delete
  CUTBUFFER=$reg
  zle .vi-put-before
}
zle -N vim-delete
zle -N vim-change
zle -N vim-visual-put

for m in vicmd visual; do
  bindkey -M $m 'c' vi-yank
  bindkey -M $m 'x' vi-delete
  bindkey -M $m 'd' vim-delete
  bindkey -M $m 'r' vim-change
done
bindkey -M vicmd  'p' vi-put-after
bindkey -M vicmd  'P' vi-put-before
bindkey -M visual 'p' vim-visual-put
bindkey -M visual 'P' vim-visual-put

bindkey -M vicmd -s 'C' 'cc'
bindkey -M vicmd -s 'X' 'xx'
bindkey -M vicmd -s 'D' 'dd'
bindkey -M vicmd -s 'R' 'rr'

bindkey -M vicmd '^U' undo
bindkey -M viins '^U' undo
bindkey -M vicmd 'u'  undefined-key

# —— Case ———————————————————————————————————————————————
vim-swap-case() { zle vi-swap-case; (( CURSOR > 0 )) && (( CURSOR-- )) }
# Nested `zle vi-swap-case` loses the region, so swap it by hand
vim-swap-case-visual() {
  local -i a=$MARK b=$CURSOR t
  (( a > b )) && { t=$a; a=$b; b=$t }
  local out= ch
  for ch in ${(s::)BUFFER[a+1,b+1]}; do
    [[ $ch == [[:lower:]] ]] && out+=${(U)ch} || out+=${(L)ch}
  done
  BUFFER[a+1,b+1]=$out
  MARK=$a CURSOR=$b REGION_ACTIVE=1
}
zle -N vim-swap-case
zle -N vim-swap-case-visual
bindkey -M vicmd  '~' vim-swap-case
bindkey -M visual '~' vim-swap-case-visual

# —— Surround ———————————————————————————————————————————
#   s<ch> word   ds<ch> delete   rs<a><b> replace
vim-surround() {                       # <launcher> <prefix> [count]
  local ch out=
  repeat ${3:-1}; do
    # zsh's surround widgets know nothing of mnemonics, so read it here
    read -k 1 ch || return 1
    out+=${VIM_PAIRS[$ch]:-$ch}
  done
  zle -U $'\C-]'"$1$2$out"
}
vim-add-surround()        { vim-surround a iw }
vim-add-surround-visual() { vim-surround a '' }
# A two-key `ds` would make `d` ambiguous and hang on KEYTIMEOUT
# An operator waits for its motion forever, so catch `s` in viopp; non-zero aborts it
vim-opp-surround() {
  if [[ $VIM_OP == r ]]; then vim-surround r '' 2; else vim-surround d ''; fi
  return 1
}
zle -N vim-add-surround
zle -N vim-add-surround-visual
zle -N vim-opp-surround

bindkey -M vicmd 's' vim-add-surround
bindkey -M viopp 's' vim-opp-surround
# Binding visual `s` is not optional: unbound keys there fall through to vicmd,
# whose `s` appends an `iw` that visual add-surround eats as the delimiter
bindkey -M visual 's' vim-add-surround-visual
bindkey -M visual 'S' vim-add-surround-visual
for m in vicmd visual; do
  bindkey -M $m $'\C-]a' add-surround
  bindkey -M $m $'\C-]d' delete-surround
  bindkey -M $m $'\C-]r' change-surround
done

# —— Text objects ———————————————————————————————————————
# h<x> inner, a<x> around
# Both widgets read the style from $KEYS[1] (`h`), accept it as $1 instead
vim-textobj() {
  local style=${KEYS[1]/h/i} key=${VIM_PAIRS[${KEYS[2]}]:-${KEYS[2]}}
  case $key in
    ['"'\''`']) zle select-quoted    -- "$style$key" ;;
    *)          zle select-bracketed -- "$style$key" ;;
  esac
}
zle -N vim-textobj
for m in visual viopp; do
  for c in p b B t q '(' ')' '[' ']' '{' '}' '<' '>' '"' "'" '`'; do
    bindkey -M $m "h$c" vim-textobj
    bindkey -M $m "a$c" vim-textobj
  done
  bindkey -M $m 'hw' select-in-word
  bindkey -M $m 'hW' select-in-blank-word
  bindkey -M $m 'ha' select-in-shell-word
done

# —— Misc ———————————————————————————————————————————————
# Read the completion widget rather than hardcode; fzf-tab will replace it
typeset -g VIM_TAB=${${(z)"$(bindkey -M viins '^I')"}[2]:-expand-or-complete}
vim-tab() { zle vi-add-next; zle "$VIM_TAB" }
zle -N vim-tab
bindkey -M vicmd '^I' vim-tab

bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

vim-bind '^H' backward-kill-word
# Unbound, the trailing ~~ of this escape sequence lands as two case swaps
vim-bind '^[[3;2~' backward-kill-word

zle-keymap-select() { [[ $KEYMAP == vicmd ]] && print -n '\e[2 q' || print -n '\e[6 q' }
zle-line-init()     { print -n '\e[6 q' }
zle -N zle-keymap-select
zle -N zle-line-init
