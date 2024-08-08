# —— ALIASES ————————————————————

alias reload="exec zsh"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"
alias sudo='sudo ' # fix alias w/ sudo
alias dots='dotfiles'

alias l="eza --icons -F "; alias ls="l"
alias la="eza --icons -AF -s modified"
alias ld="eza --icons -AFlm -T --level=1 --time-style=relative"
alias cp="cp -r"
alias del="\rm -r"
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
alias watch="entr -pc"
alias first="head -n 1" 
alias last="tail -n 1"

alias sys="systemctl"
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"
alias suspend="systemctl suspend"
alias hibernate="$DOTS/scripts/idle-lap.sh $MON -i && /bin/systemctl hibernate"
alias off="hibernate"; alias hiber="hibernate"
alias logout="hyprctl dispatch exit"
alias lock="$DOTS/scripts/idle-lap.sh $MON -f"
bios() {
  case "${(L)1}" in
    -v) sudo dmidecode -q -t bios | grep -E "Version|Revision" | \
          tr -d "\t";;
    *) sudo systemctl reboot --firmware-setup
  esac
}

alias tar="tar -czvf"
untar() { \tar -xvf "$1" --one-top-level="$2"; }
zip() { command zip -r "$1.zip" "$1"/; }
# unzip
alias calc="bc"
alias ping="grc ping -c 5"
alias root="sudo -s"
alias kernel="uname -r"
alias about="hostnamectl | grep -E '(Operating|Model|Kernel)' | sed 's/^ *//' \
&& sudo dmidecode -q -t System | grep 'Serial' | tr -d '\t'"
alias hw="hwinfo --short"
alias user="echo $USER"
alias net="nmcli"
alias name="hostname"
alias ports='grc netstat -tulanp'
alias sockets='grc netstat -xlanp'
alias mac="ifconfig | grep ether | awk '{print \$2}'"
ip() {
  case "$1" in
    public  | -P) curl "http://ifconfig.me" ;;
    private | -p) hostname -I ;;
  esac
}

spin() { cur=$(pwd);
cd "$HOME/.local/share/$1" && docker compose ${@:2} && cd "$cur"; }
alias speed="fast -u --single-line"
alias clock="darshellclock"
tz() {
    TZ=$(timedatectl list-timezones | grep -i "$1" | head -n 1)
    [ -n "$TZ" ] && timedatectl set-timezone "$TZ"
    date
}
vault() { setopt LOCAL_OPTIONS NO_MONITOR
flatpak run io.github.mpobaschnig.Vaults -o .enc/"$1" &> /dev/null; }
# vault() { gocryptfs -allow_other -q -i 30m -- "$HOME/.enc/$1" "$HOME/$1"; }
alias batt="acpi -b | grep -v 'rate' | cut -d' ' -f 3-"
alias vpn="?"
wifi() {
  case "${(L)1}" in
    pass)
      ssid=$(nmcli -t -f NAME connection show --active | head -n 1)
      nmcli -s -g 802-11-wireless-security.psk connection show "${2:-$ssid}";;
    speed) fast -u --single-line;;
    *) nmcli dev wifi ${@:1}
  esac
}
alias udev="udevadm"
mic() {
  pactl load-module module-loopback 1> /dev/null
  trap "pactl unload-module module-loopback" EXIT INT TERM
  sleep infinity
}

dl() {
  case "${(L)1}" in
    video | -v) yt-dlp -P ~/dl -N 4 $2;;
    audio | -a) yt-dlp -P ~/dl -x -N 4 $2;;
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
activate() { source "$1/bin/activate"; }
alias open="handlr open"
alias handle="handlr"
alias c="code"
alias fm="ranger"
alias v="nvim"
_v() { nvim 2> /dev/null; }
t() { nvim -c ':terminal' 2> /dev/null; }
zle -N _v; zle -N t; zle -N fm

alias keys="showkey -a"
alias f="rg $RG_COLORS -iP"
alias F="grep --color=auto --group-separator=$'\n———\n' -C3 -iP"
alias fp="pgrep"
hl() { grep --color -E -- "$1|\$" "${@:2}"; }
alias re="perl -pe"
alias p="bat --style=numbers,changes,grid --color=always --tabs=2"
alias pi="kitten icat"
alias pg="less -R"
alias pd="pwd"

lc() { awk 'END {print NR, "lines"}' "$@"; }
wc() { awk '{w += NF} END {print w, "words"}' "$@"; }
type() { file --mime-type "$1" | awk '{print $NF}'; }
alias info="eza --icons -AFlOXm -T --level=0 --git --smart-group --time-style=relative"
alias space="grc lsblk -fne7 -o NAME,LABEL,SIZE,FSUSE%,MOUNTPOINTS"
much() { du -h -d 1 $1 2>/dev/null | grep --color=none '[0-9]\+G'; }
alias i="info"; alias t="type"


# Validate commands* before appending to HISTFILE
zshaddhistory() { whence ${${(z)1}[1]} > /dev/null || return 1 }

# —— SHORTCUTS ——————————————————

#     ..
alias ...="cd ../../"
alias ....="cd ../../../"

alias -g dots/="$DOTS/"
alias -g dl/="$HOME/dl/"
alias -g conf/="$HOME/.config/"
alias -g repos/="/etc/yum.repos.d/"
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
