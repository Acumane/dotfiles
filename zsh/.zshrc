# —— PATHS ——————————————————————
export PATH=/home/bren/.local/bin:$PATH
export PATH=/home/bren/.local/share/DrMemory-Linux-2.5.0/bin64:$PATH

export HOME="/home/bren"                # explicit for root
export CACHE="$HOME/.cache"
export LOCAL="$HOME/.local/share"
export DOT="$HOME/dotfiles"
export C="/mnt/c/Users/Bren"
export PROMPT_EOL_MARK=""

# pnpm
export PNPM_HOME="/home/bren/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

HISTFILE=$CACHE/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000

source "$LOCAL/zgenom/zgenom.zsh"
# zgenom autoupdate

setopt autocd                           # no cd necessary! 
stty stop undef                         # Disable freeze terminal on Ctrl+s
zle_highlight=('paste:none')            # Disable highlight on paste

# —— PROMPT —————————————————————
autoload -U colors && colors
PROMPT="%n %F{245}›%f "
RPROMPT='%F{240}%2~%f'
# Color-coded error msgs:
# exec 2>>( sed -u "s/^/${fg[white]}/; s/\$/${reset_color}/" )

# —— VIM ————————————————————
source "$DOT/zsh/keyrc.zsh"

# —— PLUGINS ————————————————————
zgenom load zsh-users/zsh-autosuggestions

# —— ALIASES ————————————————————
alias reload="source $DOT/zsh/.zshrc && echo Sourced .zshrc"

alias ls="ls -CAF --color=auto"
alias la="la -lAF --color=autoj"
alias cp="cp -r"
alias rm="rm -r"
alias rn="mv"
alias mk="touch"
alias mkd="mkdir"

alias tar='tar -czvf'
alias untar='tar -zxvf' 
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel="uname -r"
alias ip='curl ifconfig.me'
alias weather="curl 'wttr.in/Troy,⠀NY?0Fqu'"

alias dl="wget -N -P ~/dl"
alias dlv="yt-dlp -P ~/dl -f mp4"
alias dla="yt-dlp -P ~/dl -x --audio-format mp3"


alias np="pnpm"
alias py="python"
alias app="sudo dnf"
alias cq="codequestion"
alias open="explorer.exe"
alias chrome="chromium-browser"

alias find='grep --color -i'
alias search='find'
alias print="cat"
alias read="less"


alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'

# https://github.com/olets/zsh-abbr
# https://github.com/MichaelAquilina/zsh-you-should-use


# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $CACHE/zsh/zcompdump
_comp_options+=(globdots)                 # inc. hidden files.

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


# clear