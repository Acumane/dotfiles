# —— BINDINGS ————————————————————
export KEYTIMEOUT=1
bindkey -v

viem-yank () {
	zle vi-yank
	echo "$CUTBUFFER" | clip.exe
}
viem-cut () {
	zle vi-delete
	echo "$CUTBUFFER" | clip.exe
}
zle -N viem-yank
zle -N viem-cut


bindkey '^[[1;5C' vi-forward-word         # power-navigate
bindkey '^[[1;5D' vi-backward-word
bindkey '^H' vi-backward-kill-word        # power-Backspace
bindkey '^[^?' clear-screen               # clear everything but cur prompt
bindkey '^U' undo                         # undo/redo
bindkey '^Z' undo
bindkey '^R' redo

# NAVIGATION
bindkey -M vicmd 'h' vi-insert
bindkey -M vicmd 'H' vi-add-next

bindkey -M vicmd 'j' vi-backward-char
bindkey -M vicmd 'J' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'i' vi-up-line-or-history
bindkey -M vicmd 'k' vi-down-line-or-history
bindkey -M vicmd 'I' beginning-of-buffer-or-history
bindkey -M vicmd 'K' end-of-buffer-or-history


bindkey -M vicmd 'w' vi-forward-word
bindkey -M vicmd 'W' vi-backward-word
bindkey -M vicmd 'e' vi-forward-word-end
bindkey -M vicmd 'E' vi-backward-word-end

# MANIPULATION
bindkey -M vicmd 'n' vi-open-line-below
bindkey -M vicmd 'N' vi-open-line-above

bindkey -M vicmd 'c' viem-yank
bindkey -M vicmd 'x' viem-cut
bindkey -M vicmd 'r' vi-change
bindkey -M vicmd 'd' vi-delete
bindkey -M vicmd 's' vi-replace-chars

bindkey -sM vicmd 'X' 'xx'
bindkey -sM vicmd 'C' 'cc'
bindkey -M vicmd 'R' vi-change-whole-line
bindkey -M vicmd 'D' kill-whole-line

bindkey '^A' visual-line-mode

# —— MODE-DEPENDENT CURSOR ————————————————————
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.