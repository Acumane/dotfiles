# —— ALIASES ————————————————————

alias reload="exec zsh"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"
alias sudo='sudo ' # fix alias w/ sudo

alias ls="eza -F --icons" 
alias la="eza -AF --icons -s modified"
alias ld="eza -AFlm -T --level=1 --icons"
alias cp="cp -r"
alias rm="rm -r"
alias rn="mv"
alias mk="touch"
alias mkd="mkdir -p"

alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"
alias sys="systemctl"
alias suspend="systemctl suspend"
alias hibernate="systemctl hibernate"
alias logout="hyprctl dispatch exit"
alias lock="$DOTS/scripts/idle-lap.sh $MON -f"
alias bios="sudo systemctl reboot --firmware-setup"


alias tar='tar -czvf'
untar() { \tar -xvf "$1" --one-top-level="$2"; }
zip() { command zip -r "$1.zip" "$1"/; }
#     unzip
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel=" uname -r"
alias user="echo $USER"
alias net="nmcli"
ip() {
  case "${(L)1}" in
    "public"  | "-P") curl "http://ifconfig.me" ;;
    "private"  | "-p") hostname -I ;;
    "host" | "-h") hostname ;;
    "mac"  | "-m") ifconfig | grep ether | awk '{print $2}' ;;
    *) hostname -I
  esac
}

alias speed='fast -u --single-line'
alias clock="darshellclock"
alias batt="acpi -b | grep '1:' | cut -d' ' -f 3-"
alias wifi="nmcli dev wifi"
alias udev="udevadm"

alias dl="wget -N -P ~/dl"
alias dlv="yt-dlp -P ~/dl -f bv"
alias dla="yt-dlp -P ~/dl -x -f ba"

alias pn="pnpm"
alias py="python"
alias app="sudo dnf5"
alias copr="sudo dnf copr"
ver() { dnf list "$1" | grep "$1" | tr -s ' ' | cut -d' ' -f 2; }
alias files="nautilus"
alias handle="handlr"
alias open="handlr open"
alias fm="ranger"
alias mon="zfxtop"
alias v="nvim"
alias c="code"

alias keys="showkey -a"
alias f='rg -iP'
alias F="grep --color=always --group-separator=$'\n———\n' -C3 -iE"
# F() {grep --color=always --group-separator=$'\n———\n' -C3 -iE -- "$1" "${@:2}" | less -R; }
# ighlight() { grep --color -E -- "$1|\$" "${@:2}"; }
alias re='perl -pe'
alias p='bat --style=numbers,changes,grid --color=always --tabs=2'
alias pi="kitten icat"
alias pg='less -R'
type() {
  command file --mime-type "$1" | awk '{print $NF}'
}

alias wc='wc --words'
alias lc='\wc --lines'
much() {
  du -h -d 1 $1 2>/dev/null | grep '[0-9]\+G'
}

# Validate commands* before appending to HISTFILE
zshaddhistory() { whence ${${(z)1}[1]} > /dev/null || return 1 }

# —— SHORTCUTS ——————————————————

#     ..
alias ...='cd ../../'
alias ....='cd ../../../'

alias -g dots/="$DOTS/"
alias -g dl/="$HOME/dl/"
alias -g conf/="$HOME/.config/"
alias -g bin/="/bin/"
alias -g ubin/="/usr/bin/"
alias -g lbin/="$HOME/.local/bin/"
alias -g ushare/="/usr/share/"
alias -g lshare/="$HOME/.local/share/"
alias -g icons/="/usr/share/icons/"
alias -g desk/="/usr/share/applications/"
alias -g udev/="/etc/udev/rules.d/"
alias -g sys/="/etc/systemd/system/"
alias -g usys/="/etc/systemd/user/"
alias -g flat/="/var/lib/flatpak/app/"
alias -g uflat/="$HOME/.var/app/"

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
