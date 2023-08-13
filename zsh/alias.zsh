# —— ALIASES ————————————————————

alias reload="source $DOTS/zsh/zshrc"
alias bundle="antigen bundle"
alias using="antigen use"
alias plug="zplug"

alias ls="ls -CAF --color=auto"
alias la="la -lAF --color=auto"
alias cp="cp -r"
alias rm="rm -r"
alias rn="mv"
alias mk="touch"
alias mkd="mkdir"

#     reboot
#     shutdown
alias sys="systemctl"
alias suspend="systemctl suspend"
alias hibernate="systemctl hibernate"
alias bios="systemctl reboot --firmware-setup"

alias tar='tar -czvf'
alias untar='tar -zxvf' 
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel="uname -r"
alias ip='hostname -I'
alias weather="curl 'wttr.in/Troy,⠀NY?0Fqu'"

alias dl="wget -N -P ~/Downloads"
alias dlv="yt-dlp -P ~/Downloads -f mp4"
alias dla="yt-dlp -P ~/Downloads -x --audio-format mp3"

alias pn="pnpm"
alias py="python"
alias app="sudo dnf5"
alias open="nautilus"
alias code="code-insiders"

alias keys="showkey -a"
alias f='grep --color -i'
alias p='bat --color "always"'
alias s='fzf --height 100% --border=none \
--preview "bat --color 'always' {}"'

much() {
	du -h -d 1 $1 | grep '[0-9]\+G'
}

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
