# —— ALIASES ————————————————————

alias reload="exec zsh"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"
alias sudo='sudo ' # fix alias w/ sudo
alias dots='dotfiles'

alias ls="eza -F --icons" 
alias la="eza -AF --icons -s modified"
alias ld="eza -AFlm -T --level=1 --icons"
alias cp="cp -r"
alias del="rm -r"
alias rm="trash-put"
alias trash="trash-list"
alias restore="trash-restore"
alias dump="trash-empty -f"
alias rn="mv"
mk() {
  [[ "${1: -1}" == "/" ]] && mkdir -p "${1:0:-1}" \
  || touch "$1"
}
alias mkd="mkdir -p"
alias chg="entr -pc"
alias first="head" 
alias last="tail"

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
# unzip
alias calc="bc"
alias ping='ping -c 5'
alias root="sudo -s"
alias kernel=" uname -r"
alias user="echo $USER"
alias net="nmcli"
ip() {
  case "${(L)1}" in
    "public"  | "-P") curl "http://ifconfig.me" ;;
    "private" | "-p") hostname -I ;;
    "host" | "-h") hostname ;;
    "mac"  | "-m") ifconfig | grep ether | awk '{print $2}' ;;
    *) hostname -I
  esac
}

alias speed='fast -u --single-line'
alias clock="darshellclock"
vault() { setopt LOCAL_OPTIONS NO_MONITOR
flatpak run io.github.mpobaschnig.Vaults -o .enc/"$1" &> /dev/null; }
alias batt="acpi -b | grep -v 'rate' | cut -d' ' -f 3-"
alias wifi="nmcli dev wifi"
alias udev="udevadm"

dl() {
  case "${(L)1}" in
    "video" | "-v") yt-dlp -P ~/dl -N 4 $2;;
    "audio" | "-a") yt-dlp -P ~/dl -x -N 4 $2;;
    *) wget -N -P ~/dl $1
  esac
}
alias push="tailscale file cp"
alias pull="sudo tailscale file get"

alias pn="pnpm"
alias py="python"
alias app="sudo dnf5"
alias copr="sudo dnf copr"
ver() { dnf list "$1" | grep "$1" | tr -s ' ' | cut -d' ' -f 2; }
alias open="handlr open"
alias handle="handlr"
alias c="code"
alias fm="ranger"
v() { nvim 2> /dev/null; }
t() { nvim -c ':terminal' 2> /dev/null; }
zle -N v; zle -N t; zle -N fm


alias keys="showkey -a"
alias f='rg -iP'
alias F="grep --color=always --group-separator=$'\n———\n' -C3 -iE"
alias fp="pgrep"
# F() {grep --color=always --group-separator=$'\n———\n' -C3 -iE -- "$1" "${@:2}" | less -R; }
# hl() { grep --color -E -- "$1|\$" "${@:2}"; }
alias re='perl -pe'
alias p='bat --style=numbers,changes,grid --color=always --tabs=2'
alias pi="kitten icat"
alias pg='less -R'
alias pd="pwd"
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
alias -g usb/="/run/media/$USER/"
alias -g trash/="$HOME/.local/share/Trash/files"

# —— WIDGETS ————————————————————

opener() {
  IFS=$'\n'; setopt LOCAL_OPTIONS NO_MONITOR
  files=($(fd -0LI --type f --color=always | fzf -m --read0 --query="$BUFFER" \
    --bind='alt-v:reload(fd -0LHI --type=f --exclude=.git --max-depth=4 --color=always)' \
    --preview 'bat -n --color=always {}'))
  for file in "${files[@]}"; do
    xdg-open "$file" &> /dev/null
  done
  zle reset-prompt
}
zle -N opener

search() {
  [ -z "$BUFFER" ] && return 1
  IFS=$'\n'; setopt LOCAL_OPTIONS NO_MONITOR
  files=($(rga -i --no-messages --max-count=1 --line-number --field-match-separator '\x00' --no-heading "$BUFFER" |
    perl -pe 's/(.+)\x00(\d+)\x00(.*)/`echo "$1" | lscolors | tr -d "\n"` . ":" . $2/e' |
    fzf -m --delimiter : --preview 'bat -n --color=always {1} --highlight-line {2}' --preview-window '+{2}/2'))
  for file in "${files[@]}"; do
    name=$(echo "$file" | perl -pe 's/(.+):\d+$/$1/')
    xdg-open "$name" &> /dev/null
  done
  BUFFER=""
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

files() { 
  setopt LOCAL_OPTIONS NO_MONITOR
  local DIR="${1:-.}"
  nautilus "$DIR" &> /dev/null & disown
}
zle -N files