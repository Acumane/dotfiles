# —— ALIASES ————————————————————

alias reload="exec zsh"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"

alias ls="eza -F --icons" 
alias la="eza -AF --icons -s modified"
alias ld="eza -AFlm -T --level=1 --icons"
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
alias logout="hyprctl dispatch exit"
alias lock="$DOTS/scripts/idle.sh $MON -f"
alias bios="systemctl reboot --firmware-setup"


alias tar='tar -czvf'
alias untar='\tar -xvf' 
zip() {
  command zip -r "$1.zip" "$1"/
}
#     unzip
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel=" uname -r"
alias user="echo $USER"
alias net="nmcli"
ip() { # 
  case "${(L)1}" in
    "public"  | "-P") curl "http://ifconfig.me" ;;
    "private"  | "-p") hostname -I ;;
    "host" | "-h") hostname ;;
    "mac"  | "-m") ifconfig | grep ether | awk '{print $2}' ;;
    *) hostname -I
  esac
}

alias speed='fast -u --single-line'
alias weather="curl 'wttr.in/Troy,⠀NY?0Fqu'"
alias clock="darshellclock"
alias batt="acpi -b | grep '0:' | cut -d' ' -f 3-"

alias dl="wget -N -P ~/Downloads"
alias dlv="yt-dlp -P ~/Downloads -f mp4"
alias dla="yt-dlp -P ~/Downloads -x --audio-format mp3"

alias pn="pnpm"
alias py="python"
alias app="sudo dnf5"
alias file="nautilus"
alias fm="ranger"
alias mon="zfxtop"
alias v="nvim"
alias c="code"

alias keys="showkey -a"
alias f='rg -i'
alias F='rg -i -n --context=2'
alias re='perl -pe'
alias p='bat --style=numbers,changes,grid --color=always --tabs=2'
alias pi="kitten icat"
type() {
  command file --mime-type "$1" | awk '{print $NF}'
}

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

opener() {
  IFS=$'\n'; setopt LOCAL_OPTIONS NO_MONITOR
  files=($(fd -0LI --type f --color=always | fzf -m --read0 --query="$BUFFER" \
    --bind='alt-v:reload(fd -0LHI --type=f --exclude=.git --max-depth=4 --color=always)' \
    --preview 'bat -n --color=always {}'))
  for file in "${files[@]}"; do
    xdg-open "$file" >/dev/null 2>&1 & disown
  done
  zle reset-prompt
}
zle -N opener

search() {
  if [ -z "$BUFFER" ]; then return 1; fi
  IFS=$'\n'; setopt LOCAL_OPTIONS NO_MONITOR
  files=($(rga -i --no-messages --max-count=1 --line-number --field-match-separator '\x00' --no-heading "$BUFFER" |
    perl -pe 's/(.+)\x00(\d+)\x00(.*)/`echo "$1" | lscolors | tr -d "\n"` . ":" . $2/e' |
    fzf -m --delimiter : --preview 'bat -n --color=always {1} --highlight-line {2}' --preview-window '+{2}/2'))
  for file in "${files[@]}"; do
    name=$(echo "$file" | perl -pe 's/(.+):\d+$/$1/')
    xdg-open "$name" >/dev/null 2>&1 & disown
  done
  zle reset-prompt
}
zle -N search

killer() {
  pids=$(ps -u ${UID:-$(id -u)} -o pid,comm,cmd \
  | fzf -m --query="$BUFFER" --header-lines=1 | awk '{print $1}')

  if [ -n "$pids" ]; then echo $pids | xargs -r kill -${1:-9}; fi
  zle reset-prompt
}
zle -N killer

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

dirs() {
  dir=$(fd -LI --type d . | fzf --query="$BUFFER" \
    --bind='alt-v:reload(fd -LHI --type=d --exclude='.git' --max-depth=4)' \
    --preview 'eza --icons -AF --color=always {}' --preview-window='30%') && cd "$dir"
  zle reset-prompt
}
zle -N dirs
