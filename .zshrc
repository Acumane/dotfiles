# —— PATHS ——————————————————————
export HOME="/home/bren"                  # explicit for root
export CACHE="$HOME/.cache"
export LOCAL="$HOME/.local/share"
export DOT="$HOME/dotfiles"
export C="/mnt/c/Users/Bren"

HISTFILE=$CACHE/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000

source "$LOCAL/zgenom/zgenom.zsh"
zgenom autoupdate

setopt autocd                             # no cd necessary! 
stty stop undef                           # Disable freeze terminal on Ctrl+s
zle_highlight=('paste:none')              # Disable highlight on paste

# —— PROMPT —————————————————————
autoload -U colors && colors
PROMPT="%n %F{245}›%f "
RPROMPT='%F{240}%2~%f'
# Color-coded error msgs:
exec 2>>( sed -u "s/^/${fg[red]}/; s/\$/${reset_color}/" )

# —— VIM ————————————————————
source "$DOT/keyrc.zsh"

# —— PLUGINS ————————————————————
zgenom load zsh-users/zsh-autosuggestions

# —— ALIASES ————————————————————
alias vim="vim -u $DOT/.vimrc"
alias open="explorer.exe"
alias app="sudo dnf"
alias zshr="source $DOT/.zshrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $CACHE/zsh/zcompdump
_comp_options+=(globdots)                 # inc. hidden files.

# clear