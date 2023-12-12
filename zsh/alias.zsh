# —— ALIASES ————————————————————

alias reload="source $DOTS/zsh/zshrc"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"

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
alias lock="xdg-screensaver lock"
alias bios="systemctl reboot --firmware-setup"


alias tar='tar -czvf'
alias untar='\tar -xvf' 
zip() {
  command zip -r "$1.zip" "$1"/
}
#     unzip
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel="uname -r"
alias ip='hostname -I'
alias speed='speedtest-cli --simple'
alias weather="curl 'wttr.in/Troy,⠀NY?0Fqu'"
alias clock="darshellclock"

alias dl="wget -N -P ~/Downloads"
alias dlv="yt-dlp -P ~/Downloads -f mp4"
alias dla="yt-dlp -P ~/Downloads -x --audio-format mp3"

alias pn="pnpm"
alias py="python"
alias app="sudo dnf5"
alias file="nautilus"
alias fm="ranger"
alias v="nvim"
alias c="code"

alias keys="showkey -a"
alias f='rg -i'
alias F='rg -i -n --context=1'
alias re='perl -pe'
alias p='bat --color=always'

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'

alias wc='wc --words'
alias lc='\wc --lines'
much() {
  du -h -d 1 $1 2>/dev/null | grep '[0-9]\+G'
}

# Validate commands* before appending to HISTFILE
zshaddhistory() { whence ${${(z)1}[1]} > /dev/null || return 1 }

# —— WIDGETS ————————————————————

open() {
  IFS=$'\n' files=($(fzf -m --query="$BUFFER" --preview 'bat -n --color=always {}' </dev/tty))
  for file in "${files[@]}"; do
    [[ -n "$file" ]] && xdg-open "$file" || return 1
  done
  zle reset-prompt
}
zle -N open

search() {
  if [ -z "$BUFFER" ]; then return 1; fi
  files=($(rga -i --max-count=1 --color=always --line-number --no-heading "$BUFFER" |
    perl -pe 's/([^:]+:[^:]+)(.*)/$1/' | perl -pe 's/\[35m//' |
    fzf --ansi -m --delimiter : \
        --preview 'bat -n --color=always {1} --highlight-line {2}' --preview-window 'top,40%,+{2}/2'))
  for file in "${files[@]}"; do
    [[ -n "$file" ]] && xdg-open "$file" || return 1
  done
  zle reset-prompt
}
zle -N search

kill() {
  pids=$(ps -u ${UID:-$(id -u)} -o pid,comm,cmd \
  | fzf -m --query="$BUFFER" --header-lines=1 | awk '{print $1}')

  if [ -n "$pids" ]; then echo $pids | xargs -r kill -${1:-9}; fi
  zle reset-prompt
}
zle -N kill

hist() {
  BUFFER=$(history 1 | cut -f4- -d' ' | fzf +s --tac --query="$BUFFER")
  zle reset-prompt; CURSOR=${#BUFFER}
}
zle -N hist

where() {
  RBUFFER=$(locate / | fzf +s)
  zle reset-prompt; CURSOR=${#BUFFER}
}
zle -N where

dir() {
  dir=$(find -L . -mindepth 1 -path '*/.*' -prune -o -type d -print 2> /dev/null |
  fzf --query="$BUFFER") && cd "$dir"
  zle reset-prompt
}
zle -N dir
