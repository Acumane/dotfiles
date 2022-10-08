export ZSH_CACHE="$HOME/.cache/zsh"

HISTFILE=$ZSH_CACHE/histfile
HISTSIZE=10000
SAVEHIST=10000

setopt autocd                               # no cd necessary! 
stty stop undef                             # Disable freeze terminal on Ctrl+s
zle_highlight=('paste:none')                # Disable highlight on paste
bindkey -v                                  # vim


# zstyle :compinstall filename '/home/bren/dotfiles/.zshrc'
autoload -Uz compinit
compinit -d $ZSH_CACHE/zcompdump

clear